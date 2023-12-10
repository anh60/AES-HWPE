# AES HWPE Accelerator

## Introduction

The Advanced Encryption Standard (AES) Hardware Processing Engine (HWPE) is a cryptographic accelerator developed to enhance data encryption and decryption capabilities on the PULPissimo platform. The project includes the Register Transfer Level (RTL) design, a Hardware Abstraction Layer (HAL), an AES C driver, and an application that configures and runs the HWPE using the AES driver:

- **RTL Design**: The foundation of the AES HWPE, providing the low-level hardware design essential for its functionality.
  
- **HAL Design**: This layer abstracts the hardware specifics, offering a more accessible interface for higher-level software interactions.
  
- **AES C Driver**: A driver written in C that facilitates communication between the HWPE and application software, simplifying the process of configuring and controlling the HWPE.

- **Example Application**: Demonstrates the practical usage of the AES HWPE. This application showcases how to configure and operate the HWPE using the provided AES driver, serving as a guide for developers to integrate and utilize the HWPE in their own projects.


### Key Specifications:
The AES accelerator supports different modes and specifications: 

- **Key Modes**: The HWPE supports both 128-bit and 256-bit key modes. 

- **Encryption and Decryption**: Designed to perform Electronic Codebook (ECB) encryption and decryption.

- **Data Management**: The AES gets data from one memory address, encrypts/decrypts it, and then stores it in another memory address. Can encrypt or decrypt up to 4GB if the hardware supports it. 

- **Configuration Flexibility**: The engine provides several configurable options, including the selection of key mode, setting a key, setting a data length, configuring input and output addresses, and toggling between encryption and decryption modes.

### Intended Use

The AES Hardware Processing Engine (HWPE) is designed for developers using the RISC-V PULPissimo architecture who need to offload AES-based cryptographic processing from the main CPU.


## Prerequisites
This testbench requires a RISC-V GCC toolchain available and installed, for
example https://github.com/pulp-platform/pulp-riscv-gnu-toolchain.

The toolchain path must be added to the system path:
```
export PULP_RISCV_GCC_TOOLCHAIN=/path/to/riscv/gcc/root
```
The testbench will look for the toolchain in `$PULP_RISCV_GCC_TOOLCHAIN/bin`.

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
   ```bash
   make update-ips
   ```
   This will solve dependencies and generate the
   simulation scripts using Bender, which will be installed if not already
   available. 

5. **Build the RTL files**
   ```bash
   make build-hw
   ```
6. **Clean and compile the workspace**
   ```bash
   make clean all 
   ```
7. **Run the simulation**
   ```bash
   make run gui=1
   ```
   Launches the ModelSim GUI for simulation.

# HWPE interface specifications
[![Documentation Status](https://readthedocs.org/projects/hwpe-doc/badge/?version=latest)](https://hwpe-doc.readthedocs.io/en/latest/?badge=latest)

See documentation on https://hwpe-doc.readthedocs.io.
