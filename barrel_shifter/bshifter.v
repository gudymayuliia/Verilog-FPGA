
module bshifter(
input wire [7:0] a,
input wire [2:0] amt,
input lr, 
output reg [7:0]  mout
    );
   reg [7:0] s0, s1, s2, s3, rs, ls;
  //right
  always @*
  begin
   s0 = amt[0] ? {a[0], a[7:1]} : a;
   s1 = amt[1] ? {s0[1:0], s0[7:2]} : s0;
   rs = amt[2] ? {s1[3:0], s1[7:4]} : s1;
  
   //left
   s2 = amt[0] ? {a[6:0], a[7]} : a;
   s3 = amt[1] ? {s2[5:0], s2[7:6]} : s2;
   ls = amt[2] ? {s3[4:0], s3[7:5]} : s3;

   if(lr == 0)
    mout = rs;
   else 
    mout = ls;
end    
 
endmodule

