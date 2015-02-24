function Dim=boxcounting(pow)
	a=1.4; b=0.3;
	max=2; 
	x0=rand()*max*2-max; y0=rand()*max*2-max; % random point in [-2,2]*[-2,2]
	% plot(x0,y0,'k*'); hold on;

	NoNewBox=0;
	N=power(2,pow);
	e=1/N;

	for i=1:1000
		[x0, y0]=henon(x0,y0,a,b); %throw away the first 1000 iterations
	end

	box_x=[]; %box_x store the value of x axis of selected boxes 
	box_y=[]; %box_y store the value of y axis of selected boxes 

	while NoNewBox<=1000 
		[x0, y0]=henon(x0,y0,a,b);
		% plot(x0,y0);
		bnum_x=floor(x0*N); bnum_y=floor(y0*N);

		if abs(x0)>2 | abs(y0)>2 %the point is not in the bounded area [-2,2]*[-2,2]
			NoNewBox=NoNewBox+1;
			continue; 
		elseif ffind(box_x,box_y,bnum_x,bnum_y,N) %the point stays in theboxes already counted
			NoNewBox=NoNewBox+1;
		else %need new box
			box_x(end+1)=bnum_x; box_y(end+1)=bnum_y;
			NoNewBox=0;
		end
	end

	% hold off;
	BoxNum=length(box_x); 
	Dim=log(BoxNum)/log(N);
end

function result=ffind(box_x,box_y,m,n,N)
	x_find= (box_x==m);
	result= ~isempty(find(box_y(x_find)==n, 1));
end

function [xp,yp]=henon(x,y,a,b)
	yp=x;
	xp=a-x.^2+b*y;
end