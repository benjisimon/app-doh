(android.util.Log:i "on-create.scm" "Running on-create")

(android.app.Activity:setContentView
 (as android.app.Activity (current-activity))
 (android.widget.TextView (current-activity)
                          text: "Hello World"))