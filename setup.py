"""Package configuration for `gabbi-tools`."""
import setuptools

setuptools.setup(
    name="gabbi-tools",
    version="0.1.0.dev0",
    url="https://github.hogarthww.com/zonzaltd/gabbi-tools",

    author="Tom Viner",
    author_email="tom.viner@hogarthww.com",

    description="Helpers for working with the Gabbi API testing framework.",
    long_description=open('README.rst').read(),

    packages=setuptools.find_packages('src', exclude=('tests',)),
    package_dir={'': 'src'},
    include_package_data=True,
    zip_safe=False,

    install_requires=[
        'gabbi',
    ],

    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
    ],
)
