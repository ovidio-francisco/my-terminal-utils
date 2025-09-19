from setuptools import setup

setup(
    name="recents",
    version="0.1",
    py_modules=["recents"],
    install_requires=["python-rofi"],
    entry_points={
        "console_scripts": [
            "recents = recents:main",
        ],
    },
)

