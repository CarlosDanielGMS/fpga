from migen import *
from litex.gen import *
from litex.soc.interconnect.csr import *

class Dot_Product(LiteXModule):
    def __init__(self, platform):

        # Importa bloco em hardware
        platform.add_source("rtl/dot_product.sv")

        # CSRs: entradas e saídas
        self.start = CSRStorage(fields=[
            CSRField("start", size=1, offset=0, pulse=True),  # Sinal start, apenas um pulso
        ])

        self.a0 = CSRStorage(32)
        self.a1 = CSRStorage(32)
        self.a2 = CSRStorage(32)
        self.a3 = CSRStorage(32)
        self.a4 = CSRStorage(32)
        self.a5 = CSRStorage(32)
        self.a6 = CSRStorage(32)
        self.a7 = CSRStorage(32)

        self.b0 = CSRStorage(32)
        self.b1 = CSRStorage(32)
        self.b2 = CSRStorage(32)
        self.b3 = CSRStorage(32)
        self.b4 = CSRStorage(32)
        self.b5 = CSRStorage(32)
        self.b6 = CSRStorage(32)
        self.b7 = CSRStorage(32)      

        self.done = CSRStatus(1, name="done")  
        self.result = CSRStatus(64, name="result")      

        # sinais internos
        start_sig = Signal()

        a0_sig = Signal(32)
        a1_sig = Signal(32)
        a2_sig = Signal(32)
        a3_sig = Signal(32)
        a4_sig = Signal(32)
        a5_sig = Signal(32)
        a6_sig = Signal(32)
        a7_sig = Signal(32)
        
        b0_sig = Signal(32)
        b1_sig = Signal(32)
        b2_sig = Signal(32)
        b3_sig = Signal(32)
        b4_sig = Signal(32)
        b5_sig = Signal(32)
        b6_sig = Signal(32)
        b7_sig = Signal(32)

        done_sig = Signal()
        result_sig = Signal(64)

        # instância do módulo systemverilog
        self.specials += Instance("dot_product",
            i_clock = ClockSignal(),
            i_reset = ResetSignal(),
            i_start = start_sig,

            i_a0 = a0_sig,
            i_a1 = a1_sig,
            i_a2 = a2_sig,
            i_a3 = a3_sig,
            i_a4 = a4_sig,
            i_a5 = a5_sig,
            i_a6 = a6_sig,
            i_a7 = a7_sig,

            i_b0 = b0_sig,
            i_b1 = b1_sig,
            i_b2 = b2_sig,
            i_b3 = b3_sig,
            i_b4 = b4_sig,
            i_b5 = b5_sig,
            i_b6 = b6_sig,
            i_b7 = b7_sig,
            
            o_done = done_sig,
            o_result = result_sig
        )

        # mapeamento do csr
        self.comb += [
            start_sig.eq(self.start.fields.start),

            a0_sig.eq(self.a0.storage),
            a1_sig.eq(self.a1.storage),
            a2_sig.eq(self.a2.storage),
            a3_sig.eq(self.a3.storage),
            a4_sig.eq(self.a4.storage),
            a5_sig.eq(self.a5.storage),
            a6_sig.eq(self.a6.storage),
            a7_sig.eq(self.a7.storage),

            b0_sig.eq(self.b0.storage),
            b1_sig.eq(self.b1.storage),
            b2_sig.eq(self.b2.storage),
            b3_sig.eq(self.b3.storage),
            b4_sig.eq(self.b4.storage),
            b5_sig.eq(self.b5.storage),
            b6_sig.eq(self.b6.storage),
            b7_sig.eq(self.b7.storage),

            self.done.status.eq(done_sig),
            self.result.status.eq(result_sig)
        ]
