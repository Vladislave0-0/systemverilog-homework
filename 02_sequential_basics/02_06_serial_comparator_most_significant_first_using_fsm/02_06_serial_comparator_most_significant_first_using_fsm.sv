//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_comparator_least_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // States
  enum logic[1:0]
  {
     st_equal       = 2'b00,
     st_a_less_b    = 2'b01,
     st_a_greater_b = 2'b10
  }
  state, new_state;

  // State transition logic
  always_comb
  begin
    new_state = state;

    // This lint warning is bogus because we assign the default value above
    // verilator lint_off CASEINCOMPLETE

    case (state)
      st_equal       : if (~ a &   b) new_state = st_a_less_b;
                  else if (  a & ~ b) new_state = st_a_greater_b;
      st_a_less_b    : if (  a & ~ b) new_state = st_a_greater_b;
      st_a_greater_b : if (~ a &   b) new_state = st_a_less_b;
    endcase

    // verilator lint_on  CASEINCOMPLETE
  end

  // Output logic
  assign a_eq_b      = (a == b) & (state == st_equal);
  assign a_less_b    = (~ a &   b) | (a == b & state == st_a_less_b);
  assign a_greater_b = (  a & ~ b) | (a == b & state == st_a_greater_b);

  always_ff @ (posedge clk)
    if (rst)
      state <= st_equal;
    else
      state <= new_state;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_comparator_most_significant_first_using_fsm
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output a_less_b,
  output a_eq_b,
  output a_greater_b
);

  // Task:
  // Implement a serial comparator module similar to the previus exercise
  // but use the Finite State Machine to evaluate the result.
  // Most significant bits arrive first.

  typedef enum logic [1:0] {
    EQUAL,        // A == B
    A_GREATER,    // A > B
    A_LESS        // A < B
  } state_t;

  state_t current_state, next_state;

  always_comb begin
    next_state = current_state;
    
    case (current_state)
      EQUAL: begin
        if (a > b) next_state = A_GREATER;
        else if (a < b) next_state = A_LESS;
      end
    endcase
  end

  assign a_eq_b      = (current_state == EQUAL) && (a == b);
  assign a_less_b    = (current_state == A_LESS) || 
                      ((current_state == EQUAL) && (a < b));
  assign a_greater_b = (current_state == A_GREATER) || 
                      ((current_state == EQUAL) && (a > b));

  always_ff @(posedge clk) begin
    if (rst)
      current_state <= EQUAL;
    else
      current_state <= next_state;
  end

endmodule
