
# vim: set tabstop=2 shiftwidth=2 softtabstop=2 cc=100;

every 10.minutes do
  command "resque work"
end
