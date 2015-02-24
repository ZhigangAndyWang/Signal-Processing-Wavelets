function Dim=boxcounting1(pow)
	a=1.4; b=0.3;
	max=2; 
	x0=rand()*max*2-max; y0=rand()*max*2-max; % random point in [-2,2]*[-2,2]

	NoNewBox=0;
	N=power(2,pow);
	e=1/N;
	BoxNum=0;

	for i=1:1000
		[x0, y0]=henon(x0,y0,a,b); %throw away the first 1000 iterations
	end

	box_counted=zeros(2*max*N);

	while NoNewBox<=1000 
		[x0, y0]=henon(x0,y0,a,b); 
		% plot(x0,y0);
		bid_x=floor(x0*N)+max*N; bid_y=floor(y0*N)+max*N;

		if abs(x0)>2 | abs(y0)>2 %the point is not in the bounded area [-2,2]*[-2,2]
			NoNewBox=NoNewBox+1;
			disp('Out Of Bounded Area');
			break; 
		elseif box_counted(bid_x,bid_y)==1 %the point stays in theboxes already counted
			NoNewBox=NoNewBox+1;
		else %need new box
			box_counted(bid_x,bid_y)=1;
			BoxNum=BoxNum+1;
			NoNewBox=0;
		end
	end

	% hold off;
	Dim=log(BoxNum)/log(N);
end

function [xp,yp]=henon(x,y,a,b)
	yp=x;
	xp=a-x.^2+b*y;
end