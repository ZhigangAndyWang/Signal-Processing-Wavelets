function a4q1
    
 %    y1 = linspace(-4,4,20);
	% y2 = linspace(-4,4,20);

	% % % creates two matrices one for all the x-values on the grid, and one for
	% % % all the y-values on the grid. Note that x and y are matrices of the same
	% % % size and shape, in this case 20 rows and 20 columns
	% [x,y] = meshgrid(y1,y2);

	% % % we can use a single loop over each element to compute the derivatives at
	% % % each point (y1, y2)
	% t=0; 	% we want the derivatives at each point at t=0, i.e. the starting time
	% u = zeros(size(x));
	% v = zeros(size(x));
	% for i = 1:numel(x)
	%     Yprime = dxdt1(t,[x(i); y(i)]);
	%     u(i) = Yprime(1);
	%     v(i) = Yprime(2);
	% end

 %    quiver(x,y,u,v,'r'); 
 %    xlabel('x_1');
	% ylabel('x_2');
	% axis tight equal;



	% figure(1)
	% hold on 
	% for theta=[0:10]*pi/5
	%     x0=1e-5*[cos(theta);sin(theta)];
	%     [t,x]=ode45(@dxdt1,[0 8],x0);
	%     plot(x(:,1),x(:,2))
	% end





	% y1 = linspace(-2,1.5,20);
	% y2 = linspace(-2,2,20);

	% % % creates two matrices one for all the x-values on the grid, and one for
	% % % all the y-values on the grid. Note that x and y are matrices of the same
	% % % size and shape, in this case 20 rows and 20 columns
	% [x,y] = meshgrid(y1,y2);

	% % % we can use a single loop over each element to compute the derivatives at
	% % % each point (y1, y2)
	% t=0; 	% we want the derivatives at each point at t=0, i.e. the starting time
	% u = zeros(size(x));
	% v = zeros(size(x));
	% for i = 1:numel(x)
	%     Yprime = dxdt2(t,[x(i); y(i)]);
	%     u(i) = Yprime(1);
	%     v(i) = Yprime(2);
	% end
	% figure(2);hold on
 %    quiver(x,y,u,v,'r'); 
 %    xlabel('x_1');
	% ylabel('x_2');
	% axis tight equal;

	% % figure(2)
	% hold on 
	% for theta=[-10:10]/5
	%     x0=[theta-1 2];
	%     [t,x]=ode45(@dxdt2,[0 2],x0);
	%     plot(x(:,1),x(:,2))
	%     x0=[theta -2];
	%     [t,x]=ode45(@dxdt2,[0 2],x0);
	%     plot(x(:,1),x(:,2))
	% end
	% % plot([-2 2],[0,0],'r')
	% % plot([0,0],[-2 2],'r')
	% axis([-2 2 -2 2])





	y1 = linspace(-4,4,20);
	y2 = linspace(-4,4,20);

	% % creates two matrices one for all the x-values on the grid, and one for
	% % all the y-values on the grid. Note that x and y are matrices of the same
	% % size and shape, in this case 20 rows and 20 columns
	[x,y] = meshgrid(y1,y2);

	% % we can use a single loop over each element to compute the derivatives at
	% % each point (y1, y2)
	t=0; 	% we want the derivatives at each point at t=0, i.e. the starting time
	u = zeros(size(x));
	v = zeros(size(x));
	for i = 1:numel(x)
	    Yprime = dxdt3(t,[x(i); y(i)]);
	    u(i) = Yprime(1);
	    v(i) = Yprime(2);
	end
	figure(3);hold on
    quiver(x,y,u,v,'r'); 
    xlabel('x_1');
	ylabel('x_2');
	axis tight equal;


	r=1.844;
	n=100;
	for theta=[0:n]*2*pi/n
	    x0=r*[cos(theta);sin(theta)];
	    plot(x0(1),x0(2),'*')
	    [t,x]=ode45(@dxdt3,[0 15],x0);
	    plot(x(:,1),x(:,2))
	end


	plot([-4 4],[0,0],'g')
	plot([0,0],[-4 4],'g')
	axis([-2 2 -2 2])
	axis([-4 4 -4 4])

end

function d=dxdt1(t,x)
	d=[ 3*x(1)-1*x(2); 2*x(1)+4*x(2) ];	
end

function d=dxdt2(t,x)
	d=[ -2*x(1)+3*x(2); 7*x(1)-6*x(2) ];	
end


function d=dxdt3(t,x)
	d=[ -x(2)-x(1)+x(1).^3/3; x(1) ];	
end
