import os
import glob

BASE_VERSIONS = "versions/base"
OTHER_VERSIONS = glob.glob("versions/*")


def create_symlink(source, target):
    """
    Создает символическую ссылку из исходного пути в целевой путь.

    Args:
        source (str): Путь к исходному файлу или каталогу.
        target (str): Путь, куда будет создана символическая ссылка.
    """
    if os.path.exists(target):
        if os.path.islink(target):
            if os.readlink(target) == os.path.relpath(
                source, start=os.path.dirname(target)
            ):
                return
            else:
                os.remove(target)
        else:
            return

    os.makedirs(os.path.dirname(target), exist_ok=True)
    os.symlink(os.path.relpath(source, start=os.path.dirname(target)), target)


def create_symlinks(loader, mc_version):
    """
    Создает символические ссылки для указанных подкаталогов.

    Args:
        loader (str): Подкаталог, загрузчика модов Minecraft.
        mc_version (str): Подкаталог, версии Minecraft.
    """
    base_dir = os.path.join(BASE_VERSIONS, loader, mc_version)

    for file in glob.glob(os.path.join(base_dir, "*")):
        if os.path.isdir(file):
            continue
        for version in OTHER_VERSIONS:
            if version != base_dir:
                target_dir = os.path.join(version, loader, mc_version)
                create_symlink(file, os.path.join(target_dir, os.path.basename(file)))

    for root, dirs, files in os.walk(base_dir):
        for item in files:
            create_symlink(
                os.path.join(root, item),
                os.path.join(target_dir, os.path.relpath(root, base_dir), item),
            )


create_symlinks("fabric", "1.20.4")
