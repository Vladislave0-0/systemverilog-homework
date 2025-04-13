//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_divisibility_by_3_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output div_by_3
);

  // States
  enum logic[1:0]
  {
     mod_0 = 2'b00,
     mod_1 = 2'b01,
     mod_2 = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      mod_0 : if(new_bit) new_state = mod_1;
              else        new_state = mod_0;
      mod_1 : if(new_bit) new_state = mod_0;
              else        new_state = mod_2;
      mod_2 : if(new_bit) new_state = mod_2;
              else        new_state = mod_1;
    endcase

    // verilator lint_on CASEINCOMPLETE

  end

  // Output logic
  assign div_by_3 = state == mod_0;

  // State update
  always_ff @ (posedge clk)
    if (rst)
      state <= mod_0;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_divisibility_by_5_using_fsm
(
  input  clk,
  input  rst,
  input  new_bit,
  output logic div_by_5
);

  // Implement a module that performs a serial test if input number is divisible by 5.
  //
  // On each clock cycle, module receives the next 1 bit of the input number.
  // The module should set output to 1 if the currently known number is divisible by 5.
  //
  // Hint: new bit is coming to the right side of the long binary number `X`.
  // It is similar to the multiplication of the number by 2*X or by 2*X + 1.
  //
  // Hint 2: As we are interested only in the remainder, all operations are performed under the modulo 5 (% 5).
  // Check manually how the remainder changes under such modulo.

  enum logic [4:0] 
  {
    mod_0 = 5'b00001,
    mod_1 = 5'b00010,
    mod_2 = 5'b00100,
    mod_3 = 5'b01000,
    mod_4 = 5'b10000
  } state, next_state;

  always_ff @( posedge clk or posedge rst ) begin
    if (rst) 
      state <= mod_0;
    else     
      state <= next_state;
  end

  always_comb begin
    case (state)
      mod_0: begin
        if (~new_bit) next_state = mod_0;
        else          next_state = mod_1;
      end
      mod_1: begin
        if (~new_bit) next_state = mod_2;
        else          next_state = mod_3;
      end
      mod_2: begin
        if (~new_bit) next_state = mod_4;
        else          next_state = mod_0;
      end
      mod_3: begin
        if (~new_bit) next_state = mod_1;
        else          next_state = mod_2;
      end
      mod_4: begin
        if (~new_bit) next_state = mod_3;
        else          next_state = mod_4;
      end
    endcase
  end

  always_comb begin
    if (state == mod_0) div_by_5 = 1;
    else                div_by_5 = 0; 
  end

endmodule
