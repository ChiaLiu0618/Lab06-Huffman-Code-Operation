//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//    (C) Copyright System Integration and Silicon Implementation Laboratory
//    All Right Reserved
//		Date		: 2023/10
//		Version		: v1.0
//   	File Name   : SORT_IP.v
//   	Module Name : SORT_IP
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module SORT_IP #(parameter IP_WIDTH = 8) (
    // Input signals
    IN_character, IN_weight,
    // Output signals
    OUT_character
);

// ===============================================================
// Input & Output
// ===============================================================
input [IP_WIDTH*4-1:0]  IN_character;
input [IP_WIDTH*5-1:0]  IN_weight;

output reg [IP_WIDTH*4-1:0] OUT_character;

// ===============================================================
// Design
// ===============================================================
reg [3:0] IN_character_reg [IP_WIDTH-1:0];
reg [4:0] IN_weight_reg [IP_WIDTH-1:0];

integer i, j;

reg [3:0] char_temp;
reg [4:0] weight_temp;

generate
    case(IP_WIDTH)
        3: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[2], IN_character_reg[1],
                         IN_character_reg[0]};
            end
        end
        4: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];
                IN_character_reg[IP_WIDTH-1-3] = IN_character[(IP_WIDTH-3)*4-1:(IP_WIDTH-3)*4-4];
                IN_weight_reg[IP_WIDTH-1-3] = IN_weight[(IP_WIDTH-3)*5-1:(IP_WIDTH-3)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[3], IN_character_reg[2],
                         IN_character_reg[1], IN_character_reg[0]};
            end
        end
        5: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];
                IN_character_reg[IP_WIDTH-1-3] = IN_character[(IP_WIDTH-3)*4-1:(IP_WIDTH-3)*4-4];
                IN_weight_reg[IP_WIDTH-1-3] = IN_weight[(IP_WIDTH-3)*5-1:(IP_WIDTH-3)*5-5];
                IN_character_reg[IP_WIDTH-1-4] = IN_character[(IP_WIDTH-4)*4-1:(IP_WIDTH-4)*4-4];
                IN_weight_reg[IP_WIDTH-1-4] = IN_weight[(IP_WIDTH-4)*5-1:(IP_WIDTH-4)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[4], IN_character_reg[3], IN_character_reg[2],
                         IN_character_reg[1], IN_character_reg[0]};
            end
        end
        6: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];
                IN_character_reg[IP_WIDTH-1-3] = IN_character[(IP_WIDTH-3)*4-1:(IP_WIDTH-3)*4-4];
                IN_weight_reg[IP_WIDTH-1-3] = IN_weight[(IP_WIDTH-3)*5-1:(IP_WIDTH-3)*5-5];
                IN_character_reg[IP_WIDTH-1-4] = IN_character[(IP_WIDTH-4)*4-1:(IP_WIDTH-4)*4-4];
                IN_weight_reg[IP_WIDTH-1-4] = IN_weight[(IP_WIDTH-4)*5-1:(IP_WIDTH-4)*5-5];
                IN_character_reg[IP_WIDTH-1-5] = IN_character[(IP_WIDTH-5)*4-1:(IP_WIDTH-5)*4-4];
                IN_weight_reg[IP_WIDTH-1-5] = IN_weight[(IP_WIDTH-5)*5-1:(IP_WIDTH-5)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[5], IN_character_reg[4], IN_character_reg[3],
                         IN_character_reg[2], IN_character_reg[1], IN_character_reg[0]};
            end
        end
        7: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];
                IN_character_reg[IP_WIDTH-1-3] = IN_character[(IP_WIDTH-3)*4-1:(IP_WIDTH-3)*4-4];
                IN_weight_reg[IP_WIDTH-1-3] = IN_weight[(IP_WIDTH-3)*5-1:(IP_WIDTH-3)*5-5];
                IN_character_reg[IP_WIDTH-1-4] = IN_character[(IP_WIDTH-4)*4-1:(IP_WIDTH-4)*4-4];
                IN_weight_reg[IP_WIDTH-1-4] = IN_weight[(IP_WIDTH-4)*5-1:(IP_WIDTH-4)*5-5];
                IN_character_reg[IP_WIDTH-1-5] = IN_character[(IP_WIDTH-5)*4-1:(IP_WIDTH-5)*4-4];
                IN_weight_reg[IP_WIDTH-1-5] = IN_weight[(IP_WIDTH-5)*5-1:(IP_WIDTH-5)*5-5];
                IN_character_reg[IP_WIDTH-1-6] = IN_character[(IP_WIDTH-6)*4-1:(IP_WIDTH-6)*4-4];
                IN_weight_reg[IP_WIDTH-1-6] = IN_weight[(IP_WIDTH-6)*5-1:(IP_WIDTH-6)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[6], IN_character_reg[5], IN_character_reg[4], IN_character_reg[3],
                         IN_character_reg[2], IN_character_reg[1], IN_character_reg[0]};
            end
        end
        8: begin
            always @(*) begin
                IN_character_reg[IP_WIDTH-1] = IN_character[(IP_WIDTH)*4-1:(IP_WIDTH)*4-4];
                IN_weight_reg[IP_WIDTH-1] = IN_weight[(IP_WIDTH)*5-1:(IP_WIDTH)*5-5];
                IN_character_reg[IP_WIDTH-1-1] = IN_character[(IP_WIDTH-1)*4-1:(IP_WIDTH-1)*4-4];
                IN_weight_reg[IP_WIDTH-1-1] = IN_weight[(IP_WIDTH-1)*5-1:(IP_WIDTH-1)*5-5];
                IN_character_reg[IP_WIDTH-1-2] = IN_character[(IP_WIDTH-2)*4-1:(IP_WIDTH-2)*4-4];
                IN_weight_reg[IP_WIDTH-1-2] = IN_weight[(IP_WIDTH-2)*5-1:(IP_WIDTH-2)*5-5];
                IN_character_reg[IP_WIDTH-1-3] = IN_character[(IP_WIDTH-3)*4-1:(IP_WIDTH-3)*4-4];
                IN_weight_reg[IP_WIDTH-1-3] = IN_weight[(IP_WIDTH-3)*5-1:(IP_WIDTH-3)*5-5];
                IN_character_reg[IP_WIDTH-1-4] = IN_character[(IP_WIDTH-4)*4-1:(IP_WIDTH-4)*4-4];
                IN_weight_reg[IP_WIDTH-1-4] = IN_weight[(IP_WIDTH-4)*5-1:(IP_WIDTH-4)*5-5];
                IN_character_reg[IP_WIDTH-1-5] = IN_character[(IP_WIDTH-5)*4-1:(IP_WIDTH-5)*4-4];
                IN_weight_reg[IP_WIDTH-1-5] = IN_weight[(IP_WIDTH-5)*5-1:(IP_WIDTH-5)*5-5];
                IN_character_reg[IP_WIDTH-1-6] = IN_character[(IP_WIDTH-6)*4-1:(IP_WIDTH-6)*4-4];
                IN_weight_reg[IP_WIDTH-1-6] = IN_weight[(IP_WIDTH-6)*5-1:(IP_WIDTH-6)*5-5];
                IN_character_reg[IP_WIDTH-1-7] = IN_character[(IP_WIDTH-7)*4-1:(IP_WIDTH-7)*4-4];
                IN_weight_reg[IP_WIDTH-1-7] = IN_weight[(IP_WIDTH-7)*5-1:(IP_WIDTH-7)*5-5];

                for(i=0; i<IP_WIDTH-1 ; i=i+1) begin
                    for(j=0; j<IP_WIDTH-1-i; j=j+1) begin
                        if(IN_weight_reg[j] > IN_weight_reg[j+1]) begin
                            char_temp = IN_character_reg[j];
                            weight_temp = IN_weight_reg[j];
                            IN_character_reg[j] = IN_character_reg[j+1];
                            IN_weight_reg[j] = IN_weight_reg[j+1];
                            IN_character_reg[j+1] = char_temp;
                            IN_weight_reg[j+1] = weight_temp;
                        end
                    end
                end

                OUT_character = {IN_character_reg[7], IN_character_reg[6], IN_character_reg[5], IN_character_reg[4],
                         IN_character_reg[3], IN_character_reg[2], IN_character_reg[1], IN_character_reg[0]};
            end
        end
    endcase
endgenerate

endmodule
