//-------------------------
// Branch Unit
//-------------------------
// Determines if a branch should be taken based on flags and branch type
module branch_unit(
    input EQ_flag,GT_flag,isBgt,isBeq,isUbranch,
    output isBranchtaken
   );

wire w1,w2;
and a1(w1,EQ_flag,isBeq);
and a2(w2,GT_flag,isBgt);
or o1(isBranchtaken,w1,w2,isUbranch);

endmodule
