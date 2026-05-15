curl -L https://projectlombok.org/downloads/lombok.jar -o ~/.local/share/lombok.jar


configuration:
(after! lsp-java
  (setq lsp-java-vmargs
        (list
         "-Xmx2G"
         (concat "-javaagent:" (expand-file-name "~/.local/share/lombok.jar")))))
