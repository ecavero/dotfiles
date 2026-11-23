# Runbooks

Documentos operativos que no deben publicarse en claro.

## `ecavero-space.md.asc`

Runbook cifrado de la infraestructura de `ecavero.space` y su Lightning
Address (`donar@ecavero.space`): DNSSEC, verificación del endpoint LNURL,
rollback, hardening pendiente y respuesta a incidentes.

- **Cifrado con**: GPG, `Eduardo Cavero <ecavero@gmail.com>`
  (fingerprint `7D0A80956B8B30B843EECE5839E30EF2FBE3F97B`).
- **Descifrar**:
  ```bash
  gpg --decrypt runbooks/ecavero-space.md.asc > /tmp/ecavero-space.md
  ```
- **Volver a cifrar** tras editar:
  ```bash
  gpg --batch --yes --encrypt --armor \
      --recipient 7D0A80956B8B30B843EECE5839E30EF2FBE3F97B \
      --output runbooks/ecavero-space.md.asc \
      /tmp/ecavero-space.md
  shred -u /tmp/ecavero-space.md
  ```
- **Nunca** commitear el `.md` en claro: está en `.gitignore`.

La subclave de cifrado expira el 2027-04-28. Renovar antes.
