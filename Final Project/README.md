# Meltdown Vulnerability Proof-of-Concept

> This project demonstrates a proof-of-concept (PoC) for the Meltdown security vulnerability as described in the paper at https://meltdownattack.com/meltdown.pdf ([arXiv:1801.01207](https://arxiv.org/abs/1801.01207))

You may want to check out the [report.pdf](docs/report.pdf) file for more details on this project. It was made as the final project for CS 305/341 - **Computer Architecture & Lab** course in Autumn 2018 at Indian Institute of Technology (IIT) Bombay, India.

This repository is mostly derived from the ideas in Meltdown paper at [arXiv:1801.01207](https://arxiv.org/abs/1801.01207) by Moritz Lipp *et al.*

## Getting Started

Follow the instructions below to get our project running on your local machine.

1. Make sure that for the purpose of this demonstration, you disable PTI and KALSR in Linux before booting into it (by using the flags `-nopti`  and `-nokalsr`).
2. Clone this repository and run `make` in `/src` directory.
3. Now run `sudo ./string_generator` in one terminal.
4. Now use the (physical) address received from the above command to run `./string_reader 0x[address]` in another terminal and see meltdown vulnerability in action.

### NOTE

- This code is tested to be working on Ubuntu systems (version 16.04, 18.04 and 18.10) with PTI and KALSR disabled. PTI (Kernel page-table isolation) as a patch effectively mitigates the Meltdown vulnerability and hence for the purpose of PoC, disabling it is necessary.
- You may also want to tune the default parameters at lines 120-125 in `meltdown.c` for better success rate/performance of the attack.

## Authors

* **Vamsi Krishna Reddy Satti** - *Initial work* - [vamsi3](https://github.com/vamsi3)
* Vighnesh Reddy Konda - [scopegeneral](https://github.com/scopegeneral)
* Niranjan Vaddi
* Sai Praneeth Reddy Sunkesula - [praneeth11009](https://github.com/praneeth11009)

## Acknowledgements

- **Institute of Applied Information Processing and Communications (IAIK), TU Graz** for their awesome [GitHub repository](https://github.com/IAIK/meltdown) on Meltdown from which our code is largely derived.
