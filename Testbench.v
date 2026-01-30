module testbench;
    reg clk = 0;
    reg reset = 1;

    cpu uut (.clk(clk), .reset(reset));

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, testbench);

        #10 reset = 0;
        #200 $finish;
    end
endmodule
