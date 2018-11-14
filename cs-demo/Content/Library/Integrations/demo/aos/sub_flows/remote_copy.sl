namespace: Integrations.demo.aos.sub_flows
flow:
  name: remote_copy
  inputs:
    - host: 10.0.44.7
    - username: root
    - password: admin@123
    - url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
  workflow:
    - extract_filename1:
        do:
          io.cloudslang.demo.aos.tools.extract_filename1:
            - url: '${url}'
        publish:
          - filename
        navigate:
          - SUCCESS: get_file
    - get_file:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - destination_file: '${filename}'
            - method: GET
        navigate:
          - SUCCESS: remote_secure_copy
          - FAILURE: on_failure
    - remote_secure_copy:
        do:
          io.cloudslang.base.remote_file_transfer.remote_secure_copy:
            - source_path: '${filename}'
            - destination_host: '${host}'
            - destination_path: /tmp
            - destination_username: '${username}'
            - destination_password:
                value: '${password}'
                sensitive: true
        publish:
          - filename: output_0
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - filename: '${filename}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      extract_filename1:
        x: 100
        y: 150
      remote_secure_copy:
        x: 700
        y: 150
        navigate:
          35b01cd0-d54c-9e54-b0cc-8ba429b57679:
            targetId: 305fccff-64f3-e466-a792-e8d1afb7018c
            port: SUCCESS
      get_file:
        x: 400
        y: 151
    results:
      SUCCESS:
        305fccff-64f3-e466-a792-e8d1afb7018c:
          x: 1000
          y: 150
