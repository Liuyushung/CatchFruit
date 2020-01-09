module LD_final_project(output reg [7:0] DATA_R, DATA_G, DATA_B,
								output reg [6:0] d7_time,
								output reg [2:0] COMM,	//8*8 select
								output reg [3:0] COMM_CLK,
								output EN,
								input CLK, clear, Left, Right);
	reg [7:0] object1 [7:0];
	reg [7:0] object2 [7:0];
	reg [7:0] object3 [7:0];	//3 kind fallng ob
	reg [7:0] people [7:0];
	reg [6:0] seg_unit, seg_ten, seg_point_u, seg_point_t;
	reg [3:0] bcd_unit, bcd_ten, bcd_point_u, bcd_point_t;
	reg [2:0] random01, random02, random03, r, r1, r2;
	reg left, right;
	reg [3:0] catch, catch2;  //1 -> left; 2 -> right
	reg flag1, flag2;
	segment7 S0(bcd_unit, A0,B0,C0,D0,E0,F0,G0);
	segment7 S1(bcd_ten, A1,B1,C1,D1,E1,F1,G1);
	segment7 S2(bcd_point_u, A2,B2,C2,D2,E2,F2,G2);
	segment7 S3(bcd_point_t, A3,B3,C3,D3,E3,F3,G3);		// BCD code -> 7-segment
	divfreq div0(CLK, CLK_div);
	divfreq1 div1(CLK, CLK_time);
	divfreq2 div2(CLK, CLK_mv);
	byte position, count, count_time, count2, index;
	integer a, b, c;// fall ob height

//初始值
	initial
		begin
			bcd_ten = 4'b0001;
			bcd_unit = 0;
			bcd_point_u = 0;
			bcd_point_t = 0;
			catch[0] = 0;
			catch[1] = 0;
			catch[2] = 0;
			catch[3] = 0;
			catch2[0] = 0;
			catch2[1] = 0;
			catch2[2] = 0;
			catch2[3] = 0;
			position = 3; 				//position表示位置, 起始點= 3
			random01 = (5*random01 + 3)%16;
			r = random01 % 8;
			random02 = (5*(random02+1) + 3)%16;
			r1 = random02 % 8;
			random03= (5*(random03+2) + 3)%16;
			r2 = random03 % 8;
			a = 0;
			b = 0;
			c = 0;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			object1[0] = 8'b11111111;		//行, 7-0
			object1[1] = 8'b11111111;
			object1[2] = 8'b11111111;
			object1[3] = 8'b11111111;
			object1[4] = 8'b11111111;
			object1[5] = 8'b11111111;
			object1[6] = 8'b11111111;
			object1[7] = 8'b11111111;
			object2[0] = 8'b11111111;
			object2[1] = 8'b11111111;
			object2[2] = 8'b11111111;
			object2[3] = 8'b11111111;
			object2[4] = 8'b11111111;
			object2[5] = 8'b11111111;
			object2[6] = 8'b11111111;
			object2[7] = 8'b11111111;
			object3[0] = 8'b11111111;
			object3[1] = 8'b11111111;
			object3[2] = 8'b11111111;
			object3[3] = 8'b11111111;
			object3[4] = 8'b11111111;
			object3[5] = 8'b11111111;
			object3[6] = 8'b11111111;
			object3[7] = 8'b11111111;
			people[0] = 8'b11111111;
			people[1] = 8'b11111111;
			people[2] = 8'b11111111;
			people[3] = 8'b01111111;
			people[4] = 8'b01111111;
			people[5] = 8'b11111111;
			people[6] = 8'b11111111;
			people[7] = 8'b11111111;
			index = 0;
			count = 0;
			count_time = 0;
			count2 = 0;
			flag1 = 0;
			flag2 = 0;
		end

		
//7段顯示器的視覺暫留
always@(posedge CLK_div)
	begin
		seg_unit[0] = A0;						//seg_unit代表秒數的個位七段顯示
		seg_unit[1] = B0;
		seg_unit[2] = C0;
		seg_unit[3] = D0;
		seg_unit[4] = E0;
		seg_unit[5] = F0;
		seg_unit[6] = G0;
		
		seg_ten[0] = A1;						//seg_ten代表十位
		seg_ten[1] = B1;
		seg_ten[2] = C1;
		seg_ten[3] = D1;
		seg_ten[4] = E1;
		seg_ten[5] = F1;
		seg_ten[6] = G1;
		
		seg_point_u[0] = A2;					//代表分數的個位
		seg_point_u[1] = B2;
		seg_point_u[2] = C2;
		seg_point_u[3] = D2;
		seg_point_u[4] = E2;
		seg_point_u[5] = F2;
		seg_point_u[6] = G2;
		
		seg_point_t[0] = A3;
		seg_point_t[1] = B3;
		seg_point_t[2] = C3;
		seg_point_t[3] = D3;
		seg_point_t[4] = E3;
		seg_point_t[5] = F3;
		seg_point_t[6] = G3;
		
		if(count_time == 2'b00)
			begin
				d7_time <= seg_unit;			//d7_time為七段顯示器的output
				COMM_CLK[3] <= 1'b1;			//COMM_CLK為七段顯示器的COM1, COM2
				COMM_CLK[2] <= 1'b0;
				COMM_CLK[1] <= 1'b1;
				COMM_CLK[0] <= 1'b1;
				count_time <= 2'b01;
			end
		else if(count_time == 2'b01)
			begin
				d7_time <= seg_ten;
				COMM_CLK[3] <= 1'b0;
				COMM_CLK[2] <= 1'b1;
				COMM_CLK[1] <= 1'b1;
				COMM_CLK[0] <= 1'b1;
				count_time <= 2'b10;
			end
		else if(count_time == 2'b10)
			begin
				d7_time <= seg_point_u;
				COMM_CLK[3] <= 1'b1;
				COMM_CLK[2] <= 1'b1;
				COMM_CLK[1] <= 1'b1;
				COMM_CLK[0] <= 1'b0;
				count_time <= 2'b11;
			end
		else
			begin
				d7_time <= seg_point_t;
				COMM_CLK[3] <= 1'b1;
				COMM_CLK[2] <= 1'b1;
				COMM_CLK[1] <= 1'b0;
				COMM_CLK[0] <= 1'b1;
				count_time <= 2'b00;
			end

	end

//計時&進位	
always@(posedge CLK_time, posedge clear)
	begin
		if(clear)
			begin
				bcd_ten <= 4'b0001;
				bcd_unit <= 0;
				flag2 = 0;
			end
		else
			begin
				if((bcd_ten != 0) || (bcd_unit != 0))
					begin
						if(flag1 == flag2)
							begin
								if(bcd_unit == 0)
									begin
										if(bcd_ten != 0)
											begin
												bcd_ten <= bcd_ten - 1;
												bcd_unit <= 4'b1001;
											end
									end
								else
									bcd_unit <= bcd_unit - 1;
							end
						else
							begin
								flag2 = flag1;
								if(bcd_unit == 9)
									begin
										if(bcd_ten != 9)
											begin
												bcd_ten <= bcd_ten + 1;
												bcd_unit <= 0;
											end
										else
											begin
												bcd_ten <= 0;
												bcd_unit <= 0;
											end
									end
								else
									bcd_unit <= bcd_unit + 1;
							end
					end
			end
	end
	
//計分&進位	
always@(posedge CLK_mv, posedge clear)
	begin
		if(clear)
			begin
				bcd_point_u <= 0;
				bcd_point_t <= 0;
			end
		else
			begin
				//left catch
				if(catch[0] == 1'b1)
					begin
						if(catch[1] == 1'b1)			//plus 1 point
							begin
								if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 1;
							end
							
						if(catch[2] == 1'b1)			//plus 2 points
							begin
								if(bcd_point_u == 4'b1000)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0001;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 2;
							end
							
						if(catch[3] == 1'b1)			//plus 3 points
							begin
								if(bcd_point_u == 4'b0111)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else if(bcd_point_u == 4'b1000)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0001;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 4'b0001;
											end
									end
								else if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0010;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 4'b0010;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 3;
							end
					end
					
					
				//right catch
				if(catch2[0] == 1'b1)
					begin
						if(catch2[1] == 1'b1)			//plus 1 point
							begin
								if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 1;
							end
							
						if(catch2[2] == 1'b1)			//plus 2 points
							begin
								if(bcd_point_u == 4'b1000)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0001;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 2;
							end
							
						if(catch2[3] == 1'b1)			//plus 3 points
							begin
								if(bcd_point_u == 4'b0111)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 0;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 0;
											end
									end
								else if(bcd_point_u == 4'b1000)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0001;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 4'b0001;
											end
									end
								else if(bcd_point_u == 4'b1001)
									begin
										if(bcd_point_t == 4'b1001)
											begin
												bcd_point_t <= 0;
												bcd_point_u <= 4'b0010;
											end
										else
											begin
												bcd_point_t <= bcd_point_t + 1;
												bcd_point_u <= 4'b0010;
											end
									end
								else
									bcd_point_u <= bcd_point_u + 3;
							end
					end
					
					
 			end
			
	end

//主畫面的視覺暫留	
always@(posedge CLK_div)
	begin
		if(index == 0)
			begin
				index = 1;
				if(count >= 7)
					count <= 0;
				else
					count <= count + 1;
		
				COMM = count;							//COMM = select, 更新每一行, 0-7
				EN = 1'b1;
				if((bcd_ten != 0) || (bcd_unit != 0))
					begin
						DATA_R <= object1[count];		
						DATA_G <= object2[count];		
						DATA_B <= object3[count];
					end
				else
					begin
						DATA_R <= object1[count];
						DATA_G <= 8'b11111111;
						DATA_B <= 8'b11111111;
					end
			end
		else
			begin
				index = 0;
				if(count2 >= 7)
					count2 <= 0;
				else
					count2 <= count2 + 1;
		
				COMM = count2;							//COMM = select, 更新每一行, 0-7
				EN = 1'b1;
				if((bcd_ten != 0) || (bcd_unit != 0))
					begin
						DATA_R <= people[count2];
						DATA_G <= people[count2];		
						DATA_B <= people[count2];
					end
				else
					begin
						DATA_R <= object1[count2];
						DATA_G <= 8'b11111111;
						DATA_B <= 8'b11111111;
					end
			end
			
			
	end
	
//遊戲
always@(posedge CLK_mv)
	begin
		
		right = Right;			//Right, Left是input
		left = Left;
		catch[0] = 0;
		catch[1] = 0;
		catch[2] = 0;
		catch[3] = 0;
		catch2[0] = 0;
		catch2[1] = 0;
		catch2[2] = 0;
		catch2[3] = 0;
		
		if(clear == 1)
			
				begin

					position = 3;
					catch[0] = 0;
					catch[1] = 0;
					catch[2] = 0;
					catch[3] = 0;
					catch2[0] = 0;
					catch2[1] = 0;
					catch2[2] = 0;
					catch2[3] = 0;
					a = 0;
					b = 8;
					c = 8;
					flag1 = 0;
					random01 = (5*random01 + 3)%16;
					r = random01 % 8;
					random02 = (5*(random02+1) + 3)%16;
					r1 = random02 % 8;
					random03= (5*(random03+2) + 3)%16;
					r2 = random03 % 8;
					object1[0] = 8'b11111111;
					object1[1] = 8'b11111111;
					object1[2] = 8'b11111111;
					object1[3] = 8'b11111111;
					object1[4] = 8'b11111111;
					object1[5] = 8'b11111111;
					object1[6] = 8'b11111111;
					object1[7] = 8'b11111111;
					object2[0] = 8'b11111111;
					object2[1] = 8'b11111111;
					object2[2] = 8'b11111111;
					object2[3] = 8'b11111111;
					object2[4] = 8'b11111111;
					object2[5] = 8'b11111111;
					object2[6] = 8'b11111111;
					object2[7] = 8'b11111111;
					object3[0] = 8'b11111111;
					object3[1] = 8'b11111111;
					object3[2] = 8'b11111111;
					object3[3] = 8'b11111111;
					object3[4] = 8'b11111111;
					object3[5] = 8'b11111111;
					object3[6] = 8'b11111111;
					object3[7] = 8'b11111111;
					people[0] = 8'b11111111;
					people[1] = 8'b11111111;
					people[2] = 8'b11111111;
					people[3] = 8'b01111111;
					people[4] = 8'b01111111;
					people[5] = 8'b11111111;
					people[6] = 8'b11111111;
					people[7] = 8'b11111111;
					
				end
////////////////////////////////////////
			//fall object 1
		if((bcd_ten != 0) || (bcd_unit != 0))
			begin
				if(a == 0)
					begin
						object1[r][a] = 1'b0;		//r -> column, a -> row
						a = a+1;
					end
				else if (a > 0 && a <= 7)
					begin
						object1[r][a-1] = 1'b1;
						object1[r][a] = 1'b0;
						a = a+1;
					end
				else if(a == 8) 
					begin
						object1[r][a-1] = 1'b1;
						random01 = (5*random01 + 3)%16;
						r = random01 % 8;
						a = 0;
					end
/////////////////////////////////////////	
			//fall object 2
				if(b == 0)
					begin
						object2[r1][b] = 1'b0;
						b = b+1;
					end
				else if (b > 0 && b <= 7)
					begin
						object2[r1][b-1] = 1'b1;
						object2[r1][b] = 1'b0;
						b = b+1;
					end
				else if(b == 8) 
					begin
						object2[r1][b-1] = 1'b1;
						random02 = (5*(random01+1) + 3)%16;
						r1 = random02 % 8;
						b = b+1;
					end
				else if(b == 9) 
					b = b+1;
				else if(b == 10) 
					b = 0;
/////////////////////////////////////////		
			//fall object 3
				if(c == 0)
					begin
						object3[r2][c] = 1'b0;
						c = c+1;
					end
				else if (c > 0 && c <= 7)
					begin
						object3[r2][c-1] = 1'b1;
						object3[r2][c] = 1'b0;
						c = c+1;
					end
				else if(c == 8) 
					begin
						object3[r2][c-1] = 1'b1;
						random03= (5*(random01+2) + 3)%16;
						r2 = random03 % 8;
						c = c+1;
					end
				else if(c == 9) 
					c = c+1;
				else if(c == 10) 
					c = c+1;
				else if(c == 11) 
					c = 0;
/////////////////////////////////////////	
			//people move		
				if((right == 1) && (position != 6))
					begin
						people[position][7] = 1'b1;
						people[(position+1)][7] = 1'b1;
						position = position + 1;
					end
				if((left == 1) && (position != 0))
					begin
						people[position][7] = 1'b1;
						people[position+1][7] = 1'b1;
						position = position - 1;
					end
				people[position][7] = 1'b0;
				people[(position+1)][7] = 1'b0;
			
			//catch object 1
				if(object1[position][7] == 0)						//left side catch
					begin
						if(position == r)
							begin
								object1[r][7] = 1'b1;
								a = 8;
								catch[0] = 1'b1;
								catch[1] = 1'b1;
							end
					end

				if (object1[(position+1)][7] == 0)				//right side catch
					begin
						if((position+1) == r)
							begin
								object1[r][7] = 1'b1;
								a = 8;
								catch2[0] = 1'b1;
								catch2[1] = 1'b1;
							end
					end
				
			//catch object2
				if(object2[position][7] == 0)						//left side catch
					begin
						if(position == r1)
							begin
								object2[r1][7] = 1'b1;
								b = 8;
								catch[0] = 1'b1;
								catch[2] = 1'b1;
							end
					end

				if (object2[(position+1)][7] == 0)				//right side catch
					begin
						if((position+1) == r1)
							begin
								object2[r1][7] = 1'b1;
								b = 8;
								catch2[0] = 1'b1;
								catch2[2] = 1'b1;
							end
					end
	
			//catch object3
				if(object3[position][7] == 0)						//left side catch
					begin
						if(position == r2)
							begin
								object3[r2][7] = 1'b1;
								b = 8;
								catch[0] = 1'b1;
								catch[3] = 1'b1;
							end
					end

				if (object3[(position+1)][7] == 0)				//right side catch
					begin
						if((position+1) == r2)
							begin
								object3[r2][7] = 1'b1;
								b = 8;
								catch2[0] = 1'b1;
								catch2[3] = 1'b1;
							end
					end
				if((catch[0] != 0) || (catch2[0] != 0))
						flag1 = flag1 + 1'b1;
				
			end
			//game over ---> GG
		else
			begin
				object1[0] = 8'b11000011;		//表示第一行, 上到下0-7
				object1[1] = 8'b10111101;
				object1[2] = 8'b10101101;
				object1[3] = 8'b11001011;
				object1[4] = 8'b11000011;
				object1[5] = 8'b10111101;
				object1[6] = 8'b10101101;
				object1[7] = 8'b11001011;
			end		
			
	end
endmodule


//秒數轉7段顯示器
module segment7(input [0:3] a, output A,B,C,D,E,F,G);

	assign A = ~(a[0]&~a[1]&~a[2] | ~a[0]&a[2] | ~a[1]&~a[2]&~a[3] | ~a[0]&a[1]&a[3]),
	       B = ~(~a[0]&~a[1] | ~a[1]&~a[2] | ~a[0]&~a[2]&~a[3] | ~a[0]&a[2]&a[3]),
			 C = ~(~a[0]&a[1] | ~a[1]&~a[2] | ~a[0]&a[3]),
			 D = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[2]&~a[3] | ~a[0]&a[1]&~a[2]&a[3] | ~a[1]&~a[2]&~a[3]),
			 E = ~(~a[1]&~a[2]&~a[3] | ~a[0]&a[2]&~a[3]),
			 F = ~(~a[0]&a[1]&~a[2] | ~a[0]&a[1]&~a[3] | a[0]&~a[1]&~a[2] | ~a[1]&~a[2]&~a[3]),
			 G = ~(a[0]&~a[1]&~a[2] | ~a[0]&~a[1]&a[2] | ~a[0]&a[1]&~a[2] | ~a[0]&a[2]&~a[3]);
			 
endmodule


		
//視覺暫留除頻器
module divfreq(input CLK, output reg CLK_div);
  reg [24:0] Count;
  always @(posedge CLK)
    begin
      if(Count > 5000)
        begin
          Count <= 25'b0;
          CLK_div <= ~CLK_div;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule

//計時除頻器
module divfreq1(input CLK, output reg CLK_time);
  reg [25:0] Count;
  initial
    begin
      CLK_time = 0;
	 end
	
  always @(posedge CLK)
    begin
      if(Count > 25000000)				//每秒2次
        begin
          Count <= 25'b0;
          CLK_time <= ~CLK_time;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 

//掉落物&人物移動除頻器
module divfreq2(input CLK, output reg CLK_mv);
  reg [35:0] Count;
  initial
    begin
      CLK_mv = 0;
	 end	
		
  always @(posedge CLK)
    begin
      if(Count > 4000000)
        begin
          Count <= 36'b0;
          CLK_mv <= ~CLK_mv;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 