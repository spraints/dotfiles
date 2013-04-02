define eval
  call(rb_p(rb_eval_string_protect($arg0,(int*)0)))
end

define redirect_stdout
  call rb_eval_string("$_old_stdout, $stdout = $stdout, File.open('/tmp/ruby-debug.' + Process.pid.to_s, 'a'); $stdout.sync = true")
end
