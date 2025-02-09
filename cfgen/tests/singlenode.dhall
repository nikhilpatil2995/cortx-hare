{-
  Copyright (c) 2020 Seagate Technology LLC and/or its Affiliates

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  For any questions about this software or licensing,
  please email opensource@seagate.com or cortx-questions@seagate.com.

-}

let Prelude = ../dhall/Prelude.dhall
let types = ../dhall/types.dhall

in
{ create_aux = Some False
, nodes =
    [ { hostname = "localhost"
      , data_iface = "eth1"
      , data_iface_type = None types.Protocol
      , m0_servers =
          Some
          [ { runs_confd = Some True
            , io_disks =
                { meta_data = None Text
                , data = [] : List Text
                }
            }
          , { runs_confd = None Bool
            , io_disks =
                { meta_data = None Text
                , data =
                    let mkPath = \(i : Natural) -> "/dev/loop" ++ Natural/show i
                    in Prelude.List.generate 10 Text mkPath
                }
            }
          ]
      , m0_clients =
          { s3 = 0
          , other = 2
          }
      }
    ]
, pools =
    [ { name = "the pool"
      , type = Some < dix | md | sns >.sns
      , disk_refs = Some
          [ { node = Some "localhost", path = "/dev/loop0" }
          , { node = Some "localhost", path = "/dev/loop1" }
          , { node = Some "localhost", path = "/dev/loop2" }
          , { node = Some "localhost", path = "/dev/loop3" }
          , { node = Some "localhost", path = "/dev/loop4" }
          , { node = Some "localhost", path = "/dev/loop5" }
          , { node = Some "localhost", path = "/dev/loop6" }
          , { node = Some "localhost", path = "/dev/loop7" }
          , { node = Some "localhost", path = "/dev/loop8" }
          , { node = Some "localhost", path = "/dev/loop9" }
          ]
      , data_units = 1
      , parity_units = 0
      , spare_units = Some 0
      , allowed_failures = None types.FailVec
      }
    ]
, profiles = None (List types.PoolsRef)
, fdmi_filters = None (List types.FdmiFilterDesc)
} : types.ClusterDesc
