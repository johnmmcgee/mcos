images := '(
    [bazzite]="bazzite-gnome"
    [bazzite-deck]="bazzite-deck-gnome"
    [bluefin]="bluefin"
    [bluefin-nvidia]="bluefin-nvidia"
    [ucore-hci]="stable-zfs"
    [ucore-hci-nvidia]="stable-nvidia-zfs"
    [ucore]="stable-zfs"
    [ucore-nvidia]="stable-nvidia-zfs"
)'


_default:
    @just --list


# Build mcos Image
build image="bluefin":
    #!/usr/bin/bash
    set -eou pipefail
    declare -A images={{ images }}
    image={{image}}
    check=${images[$image]-}
    if [[ -z "$check" ]]; then
        exit 1
    fi
    BUILD_ARGS=()
    BUILD_ARGS+=("--label" "org.opencontainers.image.title=mcos")
    BUILD_ARGS+=("--label" "org.opencontainers.image.version=localbuild")
    BUILD_ARGS+=("--build-arg" "IMAGE=${image}")
    case "${image}" in
    "aurora"*|"bluefin"*)
        skopeo inspect docker://ghcr.io/ublue-os/bluefin:stable-daily > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=${image}")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=stable-daily")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    "bazzite"*)
        skopeo inspect docker://ghcr.io/ublue-os/bazzite:stable > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=${check}")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=stable")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    "ucore-hci"*)
        skopeo inspect docker://ghcr.io/ublue-os/ucore-hci:${check} > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=ucore-hci")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=${check}")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    "ucore"*)
        skopeo inspect docker://ghcr.io/ublue-os/ucore:${check} > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=ucore")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=${check}")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    esac
    buildah build --format docker --label "org.opencontainers.image.description=mcos is my customized image of various ublue projects" ${BUILD_ARGS[@]} .
    
# Build mcos Beta Image
build-beta image="bluefin":
    #!/usr/bin/bash
    set -eou pipefail
    declare -A images={{ images }}
    image={{image}}
    check=${images[$image]-}
    if [[ -z "$check" ]]; then
        exit 1
    fi
    BUILD_ARGS=()
    BUILD_ARGS+=("--label" "org.opencontainers.image.title=mcos")
    BUILD_ARGS+=("--label" "org.opencontainers.image.version=localbuild-$(date +%Y%m%d-%H:%M:%S)")
    BUILD_ARGS+=("--build-arg" "IMAGE=${image}")
    case "${image}" in
    "aurora"*|"bluefin"*)
        skopeo inspect docker://ghcr.io/ublue-os/bluefin:beta > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=${image}")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=beta")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    "bazzite"*)
        skopeo inspect docker://ghcr.io/ublue-os/bazzite:unstable > /tmp/inspect.json
        BUILD_ARGS+=("--build-arg" "BASE_IMAGE=${check}")
        BUILD_ARGS+=("--build-arg" "TAG_VERSION=unstable")
        BUILD_ARGS+=("--tag" "localhost/mcos:${image}")
        ;;
    *)
        echo "No Image Yet..."
        exit 1
        ;;
    esac
    buildah build --format docker --label "org.opencontainers.image.description=mcos is my customized image of various ublue projects" ${BUILD_ARGS[@]} .

# Remove Image
remove image="":
    #!/usr/bin/bash
    set -eou pipefail
    declare -A images={{images}}
    image={{image}}
    check_image="$image"
    if [[ "$check_image" =~ beta ]]; then
        check_image=${check_image:0:-5}
    fi
    check=${images[$check_image]-}
    if [[ -z "$check" ]]; then
        exit 1
    fi
    podman rmi localhost/mcos:${image}

# Remove All Images
removeall:
    #!/usr/bin/bash
    set -euo pipefail
    declare -A images={{ images }}
    for image in ${!images[@]}
    do
        podman rmi localhost/mcos:"$image" || true
        podman rmi localhost/mcos:"$image"-beta || true
    done

# Rechunk Image
rechunk image="bluefin":
    #!/usr/bin/bash
    set -eou pipefail
    function sudoif(){
        if [[ "${UID}" -eq 0 ]]; then
            "$@"
        elif [[ "$(command -v sudo)" && -n "${SSH_ASKPASS:-}" ]] && [[ -n "${DISPLAY:-}" || -n "${WAYLAND_DISPLAY:-}" ]]; then
            /usr/bin/sudo --askpass "$@" || exit 1
        elif [[ "$(command -v sudo)" ]]; then
            /usr/bin/sudo "$@" || exit 1
        else
            exit 1
        fi
    }
    sudoif podman image scp ${UID}@localhost::localhost/mcos:{{image}} root@localhost::localhost/mcos:{{image}}
    CREF=$(sudoif podman create localhost/mcos:{{image}} bash)
    MOUNT=$(sudoif podman mount $CREF)
    OUT_NAME="mcos_{{image}}"
    LABELS="
        org.opencontainers.image.title=mcos
        org.opencontainers.image.version=localbuild-$(date +%Y%m%d-%H:%M:%S)
        ostree.linux=$(skopeo inspect containers-storage:localhost/mcos:{{image}} | jq -r '.Labels["ostree.linux"]')
        org.opencontainers.image.description=mcos is my customized image of various ublue projects"
    sudoif podman run --rm \
        --security-opt label=disable \
        -v "$MOUNT":/var/tree \
        -e TREE=/var/tree \
        -u 0:0 \
        ghcr.io/hhd-dev/rechunk:latest \
        /sources/rechunk/1_prune.sh
    sudoif podman run --rm \
        --security-opt label=disable \
        -v "$MOUNT":/var/tree \
        -e TREE=/var/tree \
        -v "cache_ostree:/var/ostree" \
        -e REPO=/var/ostree/repo \
        -e RESET_TIMESTAMP=1 \
        -u 0:0 \
        ghcr.io/hhd-dev/rechunk:latest \
        /sources/rechunk/2_create.sh
    sudoif podman unmount "$CREF"
    sudoif podman rm "$CREF"
    sudoif podman run --rm \
        --security-opt label=disable \
        -v "$PWD:/workspace" \
        -v "$PWD:/var/git" \
        -v cache_ostree:/var/ostree \
        -e REPO=/var/ostree/repo \
        -e PREV_REF=ghcr.io/m2giles/mcos:{{image}} \
        -e LABELS="$LABELS" \
        -e OUT_NAME="$OUT_NAME" \
        -e VERSION_FN=/workspace/version.txt \
        -e OUT_REF="oci:$OUT_NAME" \
        -e GIT_DIR="/var/git" \
        -u 0:0 \
        ghcr.io/hhd-dev/rechunk:latest \
        /sources/rechunk/3_chunk.sh
    sudoif chown ${UID}:${GROUPS} -R "${PWD}"
    sudoif podman volume rm cache_ostree
    IMAGE=$(sudoif podman pull oci:${PWD}/mcos_{{image}})
    sudoif podman tag ${IMAGE} localhost/mcos:{{image}}
    sudoif podman image scp root@localhost::localhost/mcos:{{image}} ${UID}@localhost::localhost/mcos:{{image}}
    sudoif podman rmi localhost/mcos:{{image}}
    sudoif podman rmi ghcr.io/hhd-dev/rechunk:latest
    sudoif chown ${UID}:${GROUPS} -R "${PWD}"/"${OUT_NAME}"

# Build and Rechunk
build-rechunk image="bluefin": (build image) (rechunk image)

# Cleanup
clean:
    find ${PWD}/mcos_* -maxdepth 0 -exec rm -rf {} \; || true
    rm -rf previous.manifest.json 