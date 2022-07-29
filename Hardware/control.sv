module control(
    input logic CLK, RESET, START,
	 input logic [5:0] i,
	 input logic [5:0] CUR_MESSAGE_REG,

    output logic LD_HASH, SET_COMPRESSION, COMPRESSION_EN, CTRL_LOAD_REG, load_ctr_reset, compression_ctr_reset, SET_HASH, 
                COMPRESSION_TIMER_EN, HASHLOOP_DONE
);

//two counters for loading and for compression

enum logic [2:0]{
hash_init, Halted, compress_set, compression_loop, load_mssg_sch, hash_sum //compression_start,
} State, Next_state;


always_ff @ (posedge CLK)
begin
	if (RESET) 
		State <= hash_init;
	else 
		State <= Next_state;
end

always_comb
begin
	Next_state = State;

    LD_HASH = 1'b0;
    COMPRESSION_EN = 1'b0;
    CTRL_LOAD_REG = 1'b0;
    load_ctr_reset = 1'b1;
    compression_ctr_reset = 1'b1;
	SET_HASH = 1'b0;
    SET_COMPRESSION = 1'b0;
    COMPRESSION_TIMER_EN = 1'b0;
    HASHLOOP_DONE = 1'b0;

    unique case(State)
        hash_init :
			Next_state = Halted;
		  
		Halted :
            if (START)
                Next_state = load_mssg_sch;

        load_mssg_sch :
            if(CUR_MESSAGE_REG == 6'b111111)
                Next_state = compress_set;

        compress_set :
            Next_state = compression_loop;//compression_start;

        // compression_start :
        //     Next_state = compression_loop;
        
        compression_loop :
            if(i == 6'b111111)
                Next_state = hash_sum;
					 
		hash_sum :
            Next_state = Halted;
				
//		hash_sum2 :
//            Next_state = hash_sum3;
//
//		hash_sum3 :
//            Next_state = hash_sum4;
//				
//		hash_sum4 :
//            Next_state = hash_sum5;
//
//
//
//        hash_sum5 :
//            Next_state = Halted;

    endcase

    case (State)

		hash_init :
			begin
				SET_HASH = 1'b1;		
			end
	 
        Halted : ;

        load_mssg_sch :
            begin
                CTRL_LOAD_REG = 1'b1;
                load_ctr_reset = 1'b0;
            end

        compress_set :
            begin
                SET_COMPRESSION = 1'b1;               
            end
        
        // compression_start :
        //     begin
                
        //     end

        compression_loop :
            begin
                COMPRESSION_EN = 1'b1;
                COMPRESSION_TIMER_EN = 1'b1;
                compression_ctr_reset = 1'b0;
                COMPRESSION_EN = 1'b1;
            end

        hash_sum :
            begin
                LD_HASH = 1'b1;
                HASHLOOP_DONE = 1'b1;
            end

//			hash_sum2, hash_sum3, hash_sum4, hash_sum5 :
//				begin
//					HASHLOOP_DONE = 1'b1;
//				end
//				
    endcase

end

endmodule
        

//when i = 0, set reset high on load_ctr