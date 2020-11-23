from setuptools import setup


def readme():
    with open('README.rst') as file:
        return file.read()


setup(
    name='compose_plantuml',
    version='0.2.1',
    description='converts docker-compose into plantuml',
    long_description=readme(),
    url='http://github.com/funkwerk/compose_plantuml',
    author='Stefan Rohe',
    license='MIT',
    packages=['compose_plantuml'],
    install_requires=[],
    zip_safe=False,
    classifiers=[
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3',
        'Topic :: Software Development',
        'Environment :: Console',
        'Operating System :: OS Independent',
    ],
    keywords='docker-compose plantuml docker yml',
    include_package_data=True,
    scripts=['bin/compose_plantuml'],
)
