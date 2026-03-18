RISC MICROPROCESSOR

Autumn 2025
Course: VHDL & Programmable Digital Circuits
Professor: Mrs. D. Dragomirescu
Students: TABAN, Aleksander & JOHNSEN, Brage

This is our README for the RISC microprocessor project.

During lab sessions and our free time, we built a microprocessor that includes: an arithmetic logic unit, a register bank, a data memory, an instruction memory, and a datapath.

GENERAL INFORMATION:

FPGA chip usage after synthesis:

17% used by Input/Output

6% by Flip-Flops

5% by Look-Up Tables

Our board has no clock constraints. This was determined after synthesis and implementation under:
Timing → Design Timing Summary

Operating frequency:

To determine the maximum operating frequency, we checked the report Reports → Timing Summary. The WNS (Worst Negative Slack) is equal to infinity, which indicates that the design is not constrained by a clock.

To estimate it, we analyzed the longest datapath between two flip-flops. The worst Data Path Delay is 20.659 ns, of which 10.5% is logic and 89.5% is routing.

The estimated maximum frequency is therefore:
1 / T = 48.4 MHz

ARITHMETIC AND LOGIC UNIT:

Operates as described in the project specifications.

REGISTER BANK:

Meets the project requirements. We implemented forwarding behavior: when writing to an address and simultaneously reading from that same address, we perform the operation:

QA or QB ← DATA if WRITE_ADDR == READ_ADDR

DATA MEMORY:

Works like the register bank but is larger (256 × 8 bits).

INSTRUCTION MEMORY:

64 lines of 32 bits. It is predefined and stores instruction sequences (MSB), composed of:
OP (2 bits), A (2 bits), B (2 bits), C (2 bits)

Thus:
MEMI_S(31 downto 0) = [OP A B C]

DATAPATH:

General explanation of the datapath. We divided it into an asynchronous part and a synchronous part.

The instruction memory address is always provided by the PC (Program Counter), defined concurrently.

All clocks are synchronized in the asynchronous part.

All resets are synchronized in the asynchronous part.

The pipeline output is given by QA and QB, which always read the values of A and B at stage 4 (write-back).

Stage 1 / Instruction Fetch:

We read the content at address PC from the instruction memory.

Stage 2 / Instruction Decode:

Signals are propagated to the next stage.

In case of register assignment, the value is written into the target register.

Stage 3 / Execution:

The ALU uses values A and B for the operations: ADD, MUL, NOT, OR, XOR, AND, SUB.

The output is sent to a multiplexer, then forwarded to the next stage.

Stage 4 / Data Memory:

Values are stored in data memory when the opcode is SRD (Store).

Values are read from data memory when the opcode is CRD (Load).

Stage 5 / Write-back:

Signals A and B, along with their addresses, are written back into the register bank.

HAZARD MANAGEMENT:

The program is stalled when a value is assigned and immediately reused in the next instruction.

Example:

If we assign x06 to R1 and then immediately copy it from R1 to R2, we must wait until R1 actually contains x06 in the register bank.

We therefore check that the instruction modifying a register is no longer in the datapath by stopping the program counter. This allows the processor to wait until it is ready, while continuing operations already in the datapath.

FIGURES:

Figures 1 & 2: Hazard management. We write 03 into register R2 (which already contains AA), then immediately copy it into R1. The program stalls (PC increment temporarily stops) for at least 5 clock cycles.

Figure 3: Program pipeline. We clearly see instructions progressing through different stages.

Figures 4 & 5: Load and store operations between the register bank and data memory.

Figures 6 & 7: Arithmetic operations: ADD, MUL, SUB, AND, OR, XOR, NOT.
