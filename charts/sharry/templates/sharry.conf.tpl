{{- define "sharry.conf" -}}
sharry.restserver {
  # This is the base URL this application is deployed to. This is used
  # to create absolute URLs and to configure the cookie.
  #
  # Note: Currently deploying behind a path is not supported. The URL
  # should not end in a slash.
  base-url = "http{{ if .Values.ingress.tls.enabled }}s{{ end }}://{{ .Values.host }}"


  # Where the server binds to.
  bind {
    address = 0.0.0.0
    port = {{ .Values.service.port }}
  }

  {{- with .Values.sharry.fileDownload }}
  file-download {
    # For open range requests, use this amount of data when
    # responding.
    download-chunk-size = "{{ .downloadChunkSize }}"
  }
  {{- end }}

  {{- with .Values.sharry.logging }}
  # Configures logging
  logging {
    # The format for the log messages. Can be one of:
    # Json, Logfmt, Fancy or Plain
    format = "{{ .format }}"

    # The minimum level to log. From lowest to highest:
    # Trace, Debug, Info, Warn, Error
    minimum-level = "{{ .minimumLevel }}"

    # Override the log level of specific loggers
    {{- with .levels }}
    levels = {
      {{- range $level, $value := . }}
      "{{ $level }}" = "{{ $value }}"
      {{- end }}
    }
    {{- end }}
  }
  {{- end }}

  # The alias-member feature allows to add users to an alias page to
  # automatically make all shares that were uploaded through the
  # corresponding alias available to all members. This allows to
  # search for other users via a http call. If this feature is
  # disabled, the rest call to search other users is disabled and the
  # form element is removed from the ui.
  alias-member-enabled = {{ .Values.sharry.aliasMemberEnabled }}

  {{- with .Values.sharry.webapp }}
  webapp {
    # This is shown in the top right corner of the web application
    app-name = "{{ .appName }}"

    # The icon next to the app-name. Needs to be an URL to an image.
    app-icon = "{{ .appIcon }}"

    # The icon next to the app-name when dark mode is enabled.
    app-icon-dark = "{{ .appIconDark }}"

    # The login and register pages display a logo image, by default
    # the Sharry logo. This can be changed here. It needs to be an URL
    # to an image.
    app-logo = "{{ .appLogo }}"

    # The login and register pages display a logo image. This is the
    # one used when dark mode is enabled.
    app-logo-dark = "{{ .appLogoDark }}"

    # This is markdown that is inserted as the footer on each page in
    # the ui. If left empty, a link to the project is rendered.
    app-footer = "{{ .appFooter }}"

    # Whether to display the footer on each page in the ui. Set it to
    # false to hide it.
    app-footer-visible = {{ .appFooterVisible }}

    # Chunk size used for one request. The server will re-chunk the
    # stream into smaller chunks. But the client can transfer more in
    # one requests, resulting in faster uploads.
    #
    # You might need to adjust this value depending on your setup. A
    # higher value usually means faster uploads (if the up-link is
    # good enough). It is set rather low by default, because it is a
    # safer default.
    chunk-size = "{{ .chunkSize }}"

    # Number of milliseconds the client should wait before doing a new
    # upload attempt after something failed. The length of the array
    # denotes the number of retries.
    retry-delays = [{{ join "," .retryDelays }}]

    # The login page can display a welcome message that is readable by
    # everyone. The text is processed as markdown.
    welcome-message = "{{ .welcomeMessage }}"

    # The ISO-3166-1 code of the default language to use. If a invalid
    # code is given (or one where no language is available), it falls
    # back to "gb".
    default-language = "{{ .defaultLanguage }}"

    # The interval a new authentication token is retrieved. This must
    # be at least 30s lower than `backend.auth.session-valid'.
    auth-renewal = "{{ .authRenewal }}"

    # The initial page to go to after logging in. It can be one of the
    # following: home, uploads, share
    initial-page = "{{ .initialPage }}"

    # The value for the validity that is preselected. Only values that
    # are available in the dropdown are possible to specifiy.
    default-validity = "{{ .defaultValidity }}"

    # The inital ui theme to use. Can be either 'light' or 'dark'.
    initial-theme = "{{ .initialTheme }}"

    # When only OAuth (or only Proxy Auth) is configured and only a
    # single provider, then the weapp automatically redirects to its
    # authentication page skipping the sharry login page. This will
    # also disable the logout button, since sharry is not in charge
    # anyways.
    oauth-auto-redirect = {{ .oauthAutoRedirect }}

    # A custom html snippet that is rendered into the html head
    # section of the main template. If the value is empty, a default
    # section is used for inserting a favicon configuration.
    #
    # The value is first tried to resolve to a file in the local file
    # system. If that is successful, it its content is being inserted
    # as utf8 characters. Otherwise the value given here is rendered
    # as is into the template!
    custom-head = "{{ .customHead }}"
  }
  {{- end }}

  {{- with .Values.sharry.backend }}
  backend {
    {{- with .auth }}
    # Authentication is flexible to let Sharry be integrated in other
    # environments.
    auth {

      # The secret for this server that is used to sign the authenicator
      # tokens. You can use base64 or hex strings (prefix with b64: and
      # hex:, respectively)
      server-secret = "{{ .serverSecret }}"

      # How long an authentication token is valid. The web application
      # will get a new one periodically.
      session-valid = "{{ .sessionValid }}"

      #### Login Modules
      ##
      ## The following settings configure how users are authenticated.
      ## There are several ways possible. The simplest is to
      ## authenticate agains the internal database. But often there is
      ## already a user management component and sharry can be
      ## configured to authenticated against other services.

      {{- with .fixed }}
      # A fixed login module simply checks the username and password
      # agains the information provided here. This only applies if the
      # user matches, otherwise the next login module is tried.
      fixed {
        enabled = {{ .enabled }}
        user = {{ .user | quote }}
        password = {{ .password | quote }}
        order = {{ default 10 .order }}
      }
      {{- end }}

      {{- if .http }}
      # The http authentication module sends the username and password
      # via a HTTP request and uses the response to indicate success or
      # failure.
      #
      # If the method is POST, the `body' is sent with the request and
      # the `content-type' is used.
      http {
        enabled = {{ .enabled }}
        url = "{{ .url }}"
        method = "{{ .method }}"
        body = "{{ .body }}"
        content-type = "{{ .contentType }}"
        order = {{ .order }}
      }
      {{- end }}

      {{- with .httpBasic }}
      # Use HTTP Basic authentication. An Authorization header using
      # the Basic scheme is created and the request is send to the
      # given url. The response body will be ignored, only the status
      # is inspected.
      http-basic {
        enabled = {{ .enabled }}
        url = "{{ .url }}"
        method = "{{ .method }}"
        order = {{ .order }}
      }
      {{- end }}

      {{- with .command }}
      # The command authentication module runs an external command
      # giving it the username and password. The return code indicates
      # success or failure.
      command {
        enabled = {{ .enabled }}
        program = ["{{ join "\", \"" .program }}"]
        # the return code to consider successful verification
        success = {{ .success }}
        order = {{ .order }}
      }
      {{- end }}

      # The internal authentication module checks against the internal
      # database.
      {{- with .internal }}
      internal {
        enabled = {{ .enabled }}
        order = {{ .order }}
      }
      {{- end }}

      {{- with .oauth }}
      # Uses OAuth2 "Code-Flow" for authentication against a
      # configured provider.
      #
      # A provider (like Github, Google, or Microsoft for example) must be
      # configured correctly for this to work. Each element in the array
      # results into a button on the login page.
      #
      # Examples for Github, Google and Microsoft (Azure AD) are provided
      # below. You need to setup an “application” to obtain a client_secret
      # and client_id.
      #
      # Details:
      # - enabled: allows to toggle it on or off
      # - id: a unique id that is part of the url
      # - name: a name that is displayed inside the button on the
      #   login screen
      # - icon: a fontawesome icon name for the button
      # - authorize-url: the url of the provider where the user can
      #   login and grant the permission to retrieve the user name
      # - token-url: the url used to obtain a bearer token using the
      #   response from the authentication above. The response from
      #   the provider must be json or url-form-encdode.
      # - user-url: the url to finalyy retrieve user information –
      #   only JSON responses are supported.
      # - user-id-key: the name of the field in the json response
      #   denoting the user name
      # - user-email-key: the name of the field in the json response
      #   that denotes the users email.
      oauth = {
        {{- range $provider, $conf := . }}
        "{{ $provider }}" = {
          {{- range $param, $value := $conf }}
          {{ kebabcase $param }} = {{ if kindIs "string" $value }}"{{ $value }}"{{ else }}{{ $value }}{{ end }}
          {{- end }}
        }
        {{- end }}
      }
      {{- end }}

      {{- with .proxy }}
      # Allows to inspect the request headers for finding already
      # authorized user name/email. If enabled and during login the
      # request contains these headers, they will be used to
      # automatically create accounts.
      proxy {
        enabled = {{ .enabled }}
        user-header = "{{ .userHeader }}"
        email-header = "{{ .emailHeader }}"
      }
      {{- end }}
    }
    {{- end }}

    # The database connection.
    #
    # By default a H2 file-based database is configured. You can
    # provide a postgresql or mariadb connection here. When using H2
    # use the PostgreSQL compatibility mode.
    jdbc {
      url = "jdbc:postgresql://{{ include "postgresql.v1.primary.fullname" $.Subcharts.postgresql }}:5432/{{ $.Values.postgresql.global.postgresql.auth.database }}"
      user = "{{ $.Values.postgresql.global.postgresql.auth.username }}"
      password = "{{ $.Values.postgresql.global.postgresql.auth.password }}"
    }

    {{- with .files }}
    # How files are stored.
    files {
      # The id of an enabled store from the `stores` array that should
      # be used.
      default-store = "{{ .defaultStore }}"

      # A list of possible file stores. Each entry must have a unique
      # id. The `type` is one of: default-database, filesystem, s3.
      #
      # All stores with enabled=false are
      # removed from the list. The `default-store` must be enabled.
      stores = {
        {{- range $store, $conf := .stores }}
        {{ $store }} = {
          {{- range $param, $value := $conf }}
          {{ kebabcase $param }} = {{ if kindIs "string" $value }}"{{ $value }}"{{ else }}{{ $value }}{{ end }}
          {{- end }}
        }
        {{- end }}
      }

      {{- with .copyFiles }}
      # Allows to copy files from one store to the other *before* sharry
      # will be available. It is recommended to set the `enabled` flag to
      # false afterwards and restart sharry.
      #
      # Files are only copied, they are *not* removed from the source
      # store.
      copy-files = {
        enable = {{ .enable }}

        # A key in the `backend.files` config identifying the store to
        # copy from.
        source = "{{ .source }}"

        # A key in the `backend.files` config identifying the store to
        # copy the files to.
        target = "{{ .target }}"

        # How many files to copy in parallel.
        parallel = {{ .parallel }}
      }
      {{- end }}
    }
    {{- end }}

    {{- with .computeChecksum }}
    # Checksums of uploaded files are computed in the background.
    compute-checksum = {
      # Setting this to false disables computation of checksums completely.
      enable = {{ .enable }}

      # How many ids to queue at most. If full, uploading blocks until
      # elemnts are taken off the queue
      capacity = {{ .capacity }}

      # How many checksums to compute in parallel, must be > 0. If 1,
      # they are computed sequentially.
      parallel = {{ .parallel }}

      # If true, the `parallel` option above is ignored and it will be
      # set to the number of available cores - 1 (using 1 for single
      # core machines).
      use-default = {{ .useDefault }}
    }
    {{- end }}

    {{- with .signup }}
    # Configuration for registering new users at the local database.
    # Accounts registered here are checked via the `internal'
    # authentication plugin as described above.
    signup {

      # The mode defines if new users can signup or not. It can have
      # three values:
      #
      # - open: every new user can sign up
      # - invite: new users can sign up only if they provide a correct
      #   invitation key. Invitation keys can be generated by an admin.
      # - closed: signing up is disabled.
      mode = "open"

      {{- if eq .mode "invite" }}
      # If mode == 'invite', this is the period an invitation token is
      # considered valid.
      invite-time = "{{ .inviteTime }}"

      # A password that is required when generating invitation keys.
      # This is more to protect against accidentally creating
      # invitation keys. Generating such keys is only permitted to
      # admin users.
      invite-password = "{{ .invitePassword }}"
      {{- end }}
    }
    {{- end }}

    {{- with .share }}
    share {
      # When storing binary data use chunks of this size.
      chunk-size = "{{ .chunkSize }}"

      # Maximum size of a share.
      max-size = "{{ .maxSize }}"

      # Maximum validity for uploads
      max-validity = {{ .maxValidity }}

      {{- with .databaseDomainChecks }}
      # Allows additional database checks to be translated into some
      # meaningful message to the user.
      #
      # This config is used when inspecting database error messages.
      # If the error message from the database contains the defined
      # `native` part, then the server returns a 422 with the error
      # messages given here as `message`.
      #
      # See issue https://github.com/eikek/sharry/issues/255 – the
      # example is a virus check via a postgresql extension "snakeoil".
      database-domain-checks = {
        {{- range $ext, $conf := . }}
        # Example: This message originates from postgres with an
        # enabled snakeoil extension. This extension allows to virus
        # check byte arrays. It must be setup such that the `bytea`
        # type of the filechunk table is changed to the type
        # `safe_bytea`:
        #
        # CREATE EXTENSION pg_snakeoil;
        # CREATE DOMAIN public.safe_bytea as bytea CHECK (not so_is_infected(value));
        # ALTER TABLE public.filechunk ALTER COLUMN chunkdata TYPE safe_bytea;
        {{ $ext }} = {
          enabled = {{ $conf.enabled }}
          native = {{ $conf.native }}
          message = {{ $conf.message }}
        }
        {{- end }}
      }
      {{- end }}
    }
    {{- end }}

    {{- with .cleanup }}
    cleanup {
      # Whether to enable the cleanup job that periodically
      # cleans up published, expired shares and expired invites
      enabled = {{ .enabled }}

      # The interval for the cleanup job
      interval = 14 days

      # Time of published shares past expiration to get collected by cleanup job
      invalid-age = 7 days
    }
    {{- end }}

    {{- with .mail }}
    mail {
      # Enable/Disable the mail feature.
      #
      # If it is disabled, the server will not send mails, including
      # notifications.
      #
      # If enabled, explicit SMTP settings must be provided.
      enabled = {{ .enabled }}

      # The SMTP settings that are used to sent mails with.
      {{- with .smtp }}
      smtp {
        {{- range $param, $value := .}}
        {{ kebabcase $param }} = {{ if kindIs "string" $value }}"{{ $value }}"{{ else }}{{ $value }}{{ end }}
        {{- end }}
      }
      {{- end }}

      {{- with .templates }}
      templates = {
        {{- with .download }}
        download = {
          subject = "{{ .subject }}"
          body = """{{ .body }}
"""
        }
        {{- end }}

        {{- with .alias }}
        alias = {
          subject = "{{ .subject }}"
          body = """{{ .body }}
"""
        }
        {{- end }}

        {{- with .uploadNotify }}
        upload-notify = {
          subject = "{{ .subject }}"
          body = """{{ .body }}
"""
        }
        {{- end }}
      }
      {{- end }}
    }
    {{- end }}
  }
  {{- end }}
}
{{- end }}
