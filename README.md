# AES HWPE Accelerator

## Introduction
[Provide a brief introduction about your project. Explain what it does and who it's for.]

## Prerequisites
Before you begin, ensure you have met the following requirements:
* [List any prerequisites, like software versions, libraries, etc.]

## Installation and Setup
Follow these steps to get your development environment running:

1. **Clone the repository**
   ```bash
   git clone https://github.com/anh60/AES-HWPE
   ```
2. **Navigate to the project directory**
   ```bash
   cd hwpe-tb
   ```
3. **Update the repository**
   Update the repository to make sure it's up-to-date with the latest changes.
   ```bash
   make update-ips
   ```
4. **Build the RTL files**
   Compile all the RTL (Register Transfer Level) files and other necessary components.
   ```bash
   make build-hw
   ```
5. **Clean and compile the workspace**
   Clean your workspace and prepare it for the next steps.
   ```bash
   make clean all 
   ```
7. **Run the simulation**
   Launch the ModelSim GUI for simulation.
   ```bash
   make run gui=1
   ```

## Usage
[Provide instructions on how to use your project after installation is complete.]

## Contributing to [Project Name]
To contribute to [Project Name], follow these steps:
1. Fork this repository.
2. Create a branch: `git checkout -b <branch_name>`.
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin [Project Name]/<location>`
5. Create the pull request.

Alternatively, see the GitHub documentation on [creating a pull request](https://help.github.com/articles/creating-a-pull-request/).

## Contributors
Thanks to the following people who have contributed to this project:
* [List contributors here]

## Contact
If you want to contact me you can reach me at [Your Email].

## License
This project uses the following license: [License Name].