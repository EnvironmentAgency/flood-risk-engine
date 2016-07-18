# Overrides the field error wrapper, so that we don't wrap fields with errors
# in divs, breaking GOV.UK javascript for focusing
# Normally rails wraps fields with errors like this:

# <div class="field_with_errors">
#   <label>Enter your name:</label>
#   <input type="text" />
# </div>
#
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html_tag
end
