//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//   	File Name   : HT_TOP.v
//   	Module Name : HT_TOP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

//synopsys translate_off
`include "SORT_IP.v"
//synopsys translate_on

module HT_TOP(
    // Input signals
    clk,
	rst_n,
	in_valid,
    in_weight, 
	out_mode,
    // Output signals
    out_valid, 
	out_code
);

// ===============================================================
// Input & Output Declaration
// ===============================================================
input clk, rst_n, in_valid, out_mode;
input [2:0] in_weight;

output reg out_valid, out_code;

// ===============================================================
// Reg & Wire Declaration
// ===============================================================
parameter IDLE = 3'd0, SORT = 3'd1, REORGANIZE = 3'd2, ENCODE = 3'd3, DECODE = 3'd4;
reg [2:0] state, next_state;

reg [2:0] step, next_step;

parameter A = 4'd7, B = 4'd6, C = 4'd5, E = 4'd4, I = 4'd3, L = 4'd2, O = 4'd1, V = 4'd0;

reg [16:0] Node [14:0];    // struct Node {4'b0 char c, 5'b0 int w, 4'b0 int left_node, 4'b0 int right_node}

reg [3:0] input_counter;
reg mode_reg;
integer i, j;

reg [31:0] sort_char_input;
reg [39:0] sort_weight_input;
reg [31:0] sort_char_output;

reg [9:0] huffman [14:0];    // {3'b0 encoded times, 7'b0 huffman code}
reg [3:0] node_flag;

reg [2:0] code_counter;
wire stop_call;

parameter DECODE_IDLE = 4'd8;
reg [3:0] letter;
// ===============================================================
// Design
// ===============================================================

// FINITE STATE MACHINE
always @(*) begin
    case(state)
        IDLE: next_state = (input_counter == 4'd8) ? SORT : IDLE;
        SORT: next_state = REORGANIZE;
        REORGANIZE: next_state = (step == 3'd7) ? ENCODE : SORT;
        ENCODE: next_state = (node_flag == 4'd8) ? DECODE : ENCODE;
        DECODE: next_state = (letter == DECODE_IDLE) ? IDLE : DECODE;
        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) state <= IDLE;
    else state <= next_state;
end

// IDLE state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) input_counter <= 0;
    else if((state == IDLE) && in_valid) input_counter <= input_counter + 1;
    else input_counter <= 0;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) mode_reg <= 0;
    else if((state == IDLE) && in_valid && (input_counter == 0)) mode_reg <= out_mode;
    else mode_reg <= mode_reg;
end

// SORT state
SORT_IP S0(.IN_character(sort_char_input), .IN_weight(sort_weight_input), .OUT_character(sort_char_output));

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sort_char_input <= 0;
        sort_weight_input <= 0;
    end
    else if(state == SORT) begin
        case(step)
            3'd0: begin
                sort_char_input <= {A, B, C, E, I, L, O, V};
                sort_weight_input <= {Node[A][12:8], Node[B][12:8], Node[C][12:8], Node[E][12:8], Node[I][12:8], Node[L][12:8], Node[O][12:8], Node[V][12:8]};
            end
            3'd1: begin
                sort_char_input <= {sort_char_output[31:8], 4'd8, 4'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[sort_char_output[27:24]][12:8], Node[sort_char_output[23:20]][12:8],
                                     Node[sort_char_output[19:16]][12:8], Node[sort_char_output[15:12]][12:8], Node[sort_char_output[11:8]][12:8], Node[8][12:8], 5'd0};
            end
            3'd2: begin
                sort_char_input <= {sort_char_output[31:12], 4'd9, 8'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[sort_char_output[27:24]][12:8], Node[sort_char_output[23:20]][12:8],
                                     Node[sort_char_output[19:16]][12:8], Node[sort_char_output[15:12]][12:8], Node[9][12:8], 10'd0};
            end
            3'd3: begin
                sort_char_input <= {sort_char_output[31:16], 4'd10, 12'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[sort_char_output[27:24]][12:8], Node[sort_char_output[23:20]][12:8],
                                     Node[sort_char_output[19:16]][12:8], Node[10][12:8], 15'd0};
            end
            3'd4: begin
                sort_char_input <= {sort_char_output[31:20], 4'd11, 16'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[sort_char_output[27:24]][12:8], Node[sort_char_output[23:20]][12:8],
                                     Node[11][12:8], 20'd0};
            end
            3'd5: begin
                sort_char_input <= {sort_char_output[31:24], 4'd12, 20'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[sort_char_output[27:24]][12:8], Node[12][12:8], 25'd0};
            end
            3'd6: begin
                sort_char_input <= {sort_char_output[31:28], 4'd13, 24'b0};
                sort_weight_input <= {Node[sort_char_output[31:28]][12:8], Node[13][12:8], 30'd0};
            end
            default: begin
                sort_char_input <= sort_char_input;
                sort_weight_input <= sort_weight_input;
            end
        endcase
    end
    else begin
        sort_char_input <= sort_char_input;
        sort_weight_input <= sort_weight_input;
    end
end

    // NODE
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<15; i=i+1) begin
            Node[i] <= 0;
        end
    end
    else if((state == IDLE) && in_valid) begin
        Node[A] <= (input_counter == 4'd0) ? {A, 2'd0, in_weight, 4'd0, 4'd0} : Node[A];
        Node[B] <= (input_counter == 4'd1) ? {B, 2'd0, in_weight, 4'd0, 4'd0} : Node[B];
        Node[C] <= (input_counter == 4'd2) ? {C, 2'd0, in_weight, 4'd0, 4'd0} : Node[C];
        Node[E] <= (input_counter == 4'd3) ? {E, 2'd0, in_weight, 4'd0, 4'd0} : Node[E];
        Node[I] <= (input_counter == 4'd4) ? {I, 2'd0, in_weight, 4'd0, 4'd0} : Node[I];
        Node[L] <= (input_counter == 4'd5) ? {L, 2'd0, in_weight, 4'd0, 4'd0} : Node[L];
        Node[O] <= (input_counter == 4'd6) ? {O, 2'd0, in_weight, 4'd0, 4'd0} : Node[O];
        Node[V] <= (input_counter == 4'd7) ? {V, 2'd0, in_weight, 4'd0, 4'd0} : Node[V];
        Node[8] <= 17'd0;
        Node[9] <= 17'd0;
        Node[10] <= 17'd0;
        Node[11] <= 17'd0;
        Node[12] <= 17'd0;
        Node[13] <= 17'd0;
        Node[14] <= 17'd0;
    end
    else if(state == REORGANIZE) begin
        case(step)
            3'd0: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= {4'd8, Node[sort_char_output[7:4]][12:8] + Node[sort_char_output[3:0]][12:8],
                             sort_char_output[7:4], sort_char_output[3:0]};
                Node[9] <= 17'd0;
                Node[10] <= 17'd0;
                Node[11] <= 17'd0;
                Node[12] <= 17'd0;
                Node[13] <= 17'd0;
                Node[14] <= 17'd0;
            end
            3'd1: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= {4'd9, Node[sort_char_output[11:8]][12:8] + Node[sort_char_output[7:4]][12:8],
                             sort_char_output[11:8], sort_char_output[7:4]};
                Node[10] <= 17'd0;
                Node[11] <= 17'd0;
                Node[12] <= 17'd0;
                Node[13] <= 17'd0;
                Node[14] <= 17'd0;
            end
            3'd2: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= {4'd10, Node[sort_char_output[15:12]][12:8] + Node[sort_char_output[11:8]][12:8],
                             sort_char_output[15:12], sort_char_output[11:8]};
                Node[11] <= 17'd0;
                Node[12] <= 17'd0;
                Node[13] <= 17'd0;
                Node[14] <= 17'd0;
            end
            3'd3: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= Node[10];
                Node[11] <= {4'd11, Node[sort_char_output[19:16]][12:8] + Node[sort_char_output[15:12]][12:8],
                             sort_char_output[19:16], sort_char_output[15:12]};
                Node[12] <= 17'd0;
                Node[13] <= 17'd0;
                Node[14] <= 17'd0;
            end
            3'd4: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= Node[10];
                Node[11] <= Node[11];
                Node[12] <= {4'd12, Node[sort_char_output[23:20]][12:8] + Node[sort_char_output[19:16]][12:8],
                             sort_char_output[23:20], sort_char_output[19:16]};
                Node[13] <= 17'd0;
                Node[14] <= 17'd0;
            end
            3'd5: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= Node[10];
                Node[11] <= Node[11];
                Node[12] <= Node[12];
                Node[13] <= {4'd13, Node[sort_char_output[27:24]][12:8] + Node[sort_char_output[23:20]][12:8],
                             sort_char_output[27:24], sort_char_output[23:20]};
                Node[14] <= 17'd0;
            end
            3'd6: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= Node[10];
                Node[11] <= Node[11];
                Node[12] <= Node[12];
                Node[13] <= Node[13];
                Node[14] <= {4'd14, Node[sort_char_output[31:28]][12:8] + Node[sort_char_output[27:24]][12:8],
                             sort_char_output[31:28], sort_char_output[27:24]};
            end
            default: begin
                Node[A] <= Node[A];
                Node[B] <= Node[B];
                Node[C] <= Node[C];
                Node[E] <= Node[E];
                Node[I] <= Node[I];
                Node[L] <= Node[L];
                Node[O] <= Node[O];
                Node[V] <= Node[V];
                Node[8] <= Node[8];
                Node[9] <= Node[9];
                Node[10] <= Node[10];
                Node[11] <= Node[11];
                Node[12] <= Node[12];
                Node[13] <= Node[13];
                Node[14] <= Node[14];
            end
        endcase
    end
    else begin
        for(i=0; i<15; i=i+1) begin
            Node[i] <= Node[i];
        end
    end
end

// REORGANIZE state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) step <= 0;
    else if(state == IDLE) step <= 0;
    else if(state == REORGANIZE) step <= step + 1; 
    else step <= step;
end

// ENCODE state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) node_flag <= 4'd14;
    else if(state == ENCODE) node_flag <= node_flag - 1;
    else node_flag <= 4'd14;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i=0; i<15; i=i+1) begin
            huffman[i] <= 0;
        end
    end
    else if(state == ENCODE) begin
        huffman[Node[node_flag][7:4]] <= {huffman[node_flag][9:7] + 1, huffman[node_flag][5:0], 1'b0};
        huffman[Node[node_flag][3:0]] <= {huffman[node_flag][9:7] + 1, huffman[node_flag][5:0], 1'b1};
    end
    else if(state == IDLE) begin
        for(i=0; i<15; i=i+1) begin
            huffman[i] <= 0;
        end
    end
    else begin
        for(i=0; i<15; i=i+1) begin
            huffman[i] <= huffman[i];
        end
    end
end

// DECODE state
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        out_code <= 0;
        out_valid <= 0;
        code_counter <= 0;
        letter <= I;
    end
    else if(state == DECODE) begin
        case(letter)
            DECODE_IDLE: begin
                out_code <= 0;
                out_valid <= 0;
                code_counter <= 0;
                letter <= I;
            end
            I: begin     // I
                out_code <= huffman[I][huffman[I][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[I][9:7] - 1) ? 0 : code_counter + 1;
                if(!mode_reg) letter <= (code_counter == huffman[I][9:7] - 1) ? L : I;
                else letter <= (code_counter == huffman[I][9:7] - 1) ? C : I;
            end
            L: begin     // L
                out_code <= huffman[L][huffman[L][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[L][9:7] - 1) ? 0 : code_counter + 1;
                if(!mode_reg) letter <= (code_counter == huffman[L][9:7] - 1) ? O : L;
                else letter <= (code_counter == huffman[L][9:7] - 1) ? A : L;
            end
            O: begin     // O
                out_code <= huffman[O][huffman[O][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[O][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[O][9:7] - 1) ? V : O;
            end
            V: begin     // V
                out_code <= huffman[V][huffman[V][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[V][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[V][9:7] - 1) ? E : V;
            end
            E: begin     // E
                out_code <= huffman[E][huffman[E][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[E][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[E][9:7] - 1) ? DECODE_IDLE : E;
            end
            C: begin     // C
                out_code <= huffman[C][huffman[C][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[C][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[C][9:7] - 1) ? L : C;
            end
            A: begin     // A
                out_code <= huffman[A][huffman[A][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[A][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[A][9:7] - 1) ? B : A;
            end
            B: begin     // B
                out_code <= huffman[B][huffman[B][9:7] - 1 - code_counter];
                out_valid <= 1;
                code_counter <= (code_counter == huffman[B][9:7] - 1) ? 0 : code_counter + 1;
                letter <= (code_counter == huffman[B][9:7] - 1) ? DECODE_IDLE : B;
            end
            default: begin
                out_code <= 0;
                out_valid <= 0;
                code_counter <= 0;
                letter <= I;
            end
        endcase
    end
    else begin
        out_code <= 0;
        out_valid <= 0;
        code_counter <= 0;
        letter <= I;
    end
end

endmodule
