{ ... }:
''
  layout {
      gaps 9

      center-focused-column "on-overflow"
      always-center-single-column

      preset-column-widths {
          proportion 0.5
          proportion 0.66667
          proportion 1.0
      }

      default-column-width { proportion 0.5; }

      focus-ring {
          off
      }

      border {
          on
          width 3
          active-gradient from="#fb4934" to="#fe8019" angle=45
          inactive-gradient from="#3c3836" to="#504945" angle=45
      }

      shadow {
          on
          softness 30
          spread 5
          offset x=0 y=5
          color "#0007"
      }

      struts {
      }
  }
''
