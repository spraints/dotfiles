define eval
  call (void) rb_p((unsigned long) rb_eval_string_protect($arg0,(int*)0))
end

define redirect_stdout
  call (void) rb_eval_string("$_old_stdout, $stdout = $stdout, File.open('/tmp/ruby-debug.' + Process.pid.to_s, 'a'); $stdout.sync = true")
end
