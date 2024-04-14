# This file defines how PyOxidizer application building and packaging is performed. See PyOxidizer's documentation at https://gregoryszorc.com/docs/pyoxidizer/stable/pyoxidizer.html for details of this configuration file format.

def make_exe():
    dist = default_python_distribution()
    policy = dist.make_python_packaging_policy()
    # 定义资源加载位置，优先从内存中读取，如果读取不到则在文件系统中查找
    policy.resources_location_fallback = "in-memory"
    policy.resources_location_fallback = "filesystem-relative:prefix"

    python_config = dist.make_python_interpreter_config()
    python_config.run_module = "app"

    exe = dist.to_python_executable(
        name="app",
        packaging_policy=policy,
        config=python_config,
    )

    # 添加 pdfplumber 依赖
    exe.add_python_resources(exe.pip_download(["pdfplumber"]))
    # 或者使用 requirements.txt 文件添加
    # exe.add_python_resources(exe.pip_install(["-r", "requirements.txt"]))

    # 将当前目录下的 app 包作为嵌入的资源文件
    exe.add_python_resources(exe.read_package_root(
        path=".",
        packages=["app"],
    ))
    return exe

def make_embedded_resources(exe):
    return exe.to_embedded_resources()

def make_install(exe):
    files = FileManifest()
    files.add_python_resource(".", exe)
    return files

def make_msi(exe):
    # See the full docs for more. But this will convert your Python executable
    # into a `WiXMSIBuilder` Starlark type, which will be converted to a Windows
    # .msi installer when it is built.
    return exe.to_wix_msi_builder(
        # Simple identifier of your app.
        "myapp",
        # The name of your application.
        "My Application",
        # The version of your application.
        "1.0",
        # The author/manufacturer of your application.
        "Alice Jones"
    )


def register_code_signers():
    return

register_code_signers()
register_target("exe", make_exe)
register_target("resources", make_embedded_resources, depends=["exe"], default_build_script=True)
register_target("install", make_install, depends=["exe"], default=True)
register_target("msi_installer", make_msi, depends=["exe"])
resolve_targets()
