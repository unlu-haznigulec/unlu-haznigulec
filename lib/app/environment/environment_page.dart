import 'package:auto_route/auto_route.dart';
import 'package:design_system/foundations/spacing/grid.dart';
import 'package:flutter/material.dart';
import 'package:piapiri_v2/common/utils/images_path.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_bloc.dart';
import 'package:piapiri_v2/core/app_info/bloc/app_info_event.dart';
import 'package:piapiri_v2/core/config/app_config.dart';
import 'package:piapiri_v2/core/config/router/app_router.gr.dart';
import 'package:piapiri_v2/core/config/router_locator.dart';
import 'package:piapiri_v2/core/config/service_locator.dart';
import 'package:piapiri_v2/core/config/service_locator_manager.dart';

@RoutePage()
class EnvironmentPage extends StatelessWidget {
  const EnvironmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Environment Page'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset(
              ImagesPath.darkPiapiriLoginLogo,
              scale: 4,
            ),
          ),
          const SizedBox(
            height: Grid.xxl,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              environmentButton(
                icon: Icons.engineering,
                text: 'Dev',
                onPressed: () {
                  getIt<AppInfoBloc>().add(
                    ChangeEnv(
                      callback: () {
                        AppConfig(
                          flavor: Flavor.dev,
                          name: 'dev',
                          contractUrl: 'https://kycdev.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
                          baseUrl: 'https://devpiapiri.unluco.com/service3',
                          usBaseUrl: 'https://devpiapiricapra.unluco.com:7040',
                          usWssUrl: 'https://devpiapiricapra.unluco.com:7040/marketdatahub',
                          matriksUrl: 'https://apitest.matriksdata.com',
                          cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
                          certificate: '',
                          memberKvkk:
                              'https://piapiri-test.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
                        );
                        ServiceLocatorManager.environmentReset().whenComplete(
                          () => router.pushAndPopUntil(
                            const SplashRoute(),
                            predicate: (_) => false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                width: Grid.m,
              ),
              environmentButton(
                icon: Icons.precision_manufacturing,
                text: 'Prod',
                onPressed: () {
                  getIt<AppInfoBloc>().add(
                    ChangeEnv(
                      callback: () {
                        AppConfig(
                          flavor: Flavor.prod,
                          name: 'prod',
                          contractUrl: 'https://kyc.unluco.com/api/Contract/GetFileByte?ContractRefCode=',
                          baseUrl: 'https://piapiri.unluco.com/api',
                          usBaseUrl: 'https://piapiricapra.unluco.com',
                          usWssUrl: 'https://piapiricapra.unluco.com/marketdatahub',
                          matriksUrl: 'https://api.matriksdata.com',
                          cdnKey: '62f73103-d83f-430c-a3df4ca34aad-3f05-4565',
                          certificate:
                              'LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUhsVENDQm4yZ0F3SUJBZ0lRQnFKY3BHMFc2ZVdZMjMxaUhLYTFtVEFOQmdrcWhraUc5dzBCQVFzRkFEQmcKTVFzd0NRWURWUVFHRXdKVlV6RVZNQk1HQTFVRUNoTU1SR2xuYVVObGNuUWdTVzVqTVJrd0Z3WURWUVFMRXhCMwpkM2N1WkdsbmFXTmxjblF1WTI5dE1SOHdIUVlEVlFRREV4WkhaVzlVY25WemRDQlVURk1nVWxOQklFTkJJRWN4Ck1CNFhEVEkwTURreU1EQXdNREF3TUZvWERUSTFNRGt4T1RJek5UazFPVm93Z1lBeEN6QUpCZ05WQkFZVEFsUlMKTVJJd0VBWURWUVFJREFuRXNITjBZVzVpZFd3eEVUQVBCZ05WQkFjTUNGTmhjc1N4ZVdWeU1UTXdNUVlEVlFRSwpEQ3JEbkU1TXc1d2dUVVZPUzFWTUlFUkZ4SjVGVWt4RlVpQkJUazlPeExCTklNV2V4TEJTUzBWVXhMQXhGVEFUCkJnTlZCQU1NRENvdWRXNXNkV052TG1OdmJUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0MKZ2dFQkFNUzc0eFZQYW1xZWpZSmdsekN5ajRGVER5bHFBV1FKZWRUZXp4WUgxQUdnd2FJWkJ6WDYrMDRVbElFSApGVzdOeXh2alRqMHJySXc4cjJ5ZG5QbWRmOE1RZERpK1UrSXZvZGMyVk12QlBaelVrdnNIZU95UFFPTlJJWkdpCkpFSkRETXRvMkIvTmtJVWtpOFhkNm1sdEVaZ2tNckhzUHZWVVFKY1VnNU8rMmQ4dmdwZERsdFROK0lTcnMyai8KUmJzOENGSXExTHVFbk5udDJET0NBei9kT1Q3YWhHVkJQN251VVMvTkVyT2hoWFkyQlJ2aEVWSnluTjlYL2t0SQpwSk1QcUZOWEFWem1sOTFWL0J1Y2Yvclh4UTR4c3A3dFFXOExlYWVpb1JETUI1MkRKejZxWFl6NTJvM3pJUm9oClh6ZFhFalR4bXNnNHkxOEZDOEt5enF4T1kya0NBd0VBQWFPQ0JDZ3dnZ1FrTUI4R0ExVWRJd1FZTUJhQUZKUlAKMUYyTDVLVGlwb0QrL2RqNUFPK2p2Z0pYTUIwR0ExVWREZ1FXQkJSMEUyVml3b0xlQWd4TkZCQU5jMUpUdWxLego0RENDQVNnR0ExVWRFUVNDQVI4d2dnRWJnZ3dxTG5WdWJIVmpieTVqYjIyQ0VIUnpMblYwY21Ga1pTNWpiMjB1CmRIS0NDblZ1YkhWamJ5NWpiMjJDRG5WdWJIVnRaVzVyZFd3dVkyOXRnZzkxYm14MWNHOXlkR1p2ZVM1amIyMkMKRFhWMGNtRmtaUzVqYjIwdWRIS0NEM1YwY21Ga1pXWjRMbU52YlM1MGNvSVhkWFJ5WVdSbGFXNTBaWEp1WVhScApiMjVoYkM1amIyMkNEM2QzZHk1d2FXRndhWEpwTG1OdmJZSVVkM2QzTG5SekxuVjBjbUZrWlM1amIyMHVkSEtDCkVuZDNkeTUxYm14MWJXVnVhM1ZzTG1OdmJZSVRkM2QzTG5WdWJIVndiM0owWm05NUxtTnZiWUlSZDNkM0xuVjAKY21Ga1pTNWpiMjB1ZEhLQ0UzZDNkeTUxZEhKaFpHVm1lQzVqYjIwdWRIS0NHM2QzZHk1MWRISmhaR1ZwYm5SbApjbTVoZEdsdmJtRnNMbU52YlRBK0JnTlZIU0FFTnpBMU1ETUdCbWVCREFFQ0FqQXBNQ2NHQ0NzR0FRVUZCd0lCCkZodG9kSFJ3T2k4dmQzZDNMbVJwWjJsalpYSjBMbU52YlM5RFVGTXdEZ1lEVlIwUEFRSC9CQVFEQWdXZ01CMEcKQTFVZEpRUVdNQlFHQ0NzR0FRVUZCd01CQmdnckJnRUZCUWNEQWpBL0JnTlZIUjhFT0RBMk1EU2dNcUF3aGk1bwpkSFJ3T2k4dlkyUndMbWRsYjNSeWRYTjBMbU52YlM5SFpXOVVjblZ6ZEZSTVUxSlRRVU5CUnpFdVkzSnNNSFlHCkNDc0dBUVVGQndFQkJHb3dhREFtQmdnckJnRUZCUWN3QVlZYWFIUjBjRG92TDNOMFlYUjFjeTVuWlc5MGNuVnoKZEM1amIyMHdQZ1lJS3dZQkJRVUhNQUtHTW1oMGRIQTZMeTlqWVdObGNuUnpMbWRsYjNSeWRYTjBMbU52YlM5SApaVzlVY25WemRGUk1VMUpUUVVOQlJ6RXVZM0owTUF3R0ExVWRFd0VCL3dRQ01BQXdnZ0YrQmdvckJnRUVBZFo1CkFnUUNCSUlCYmdTQ0FXb0JhQUIzQU4zY3lqU1YxK0VXQmVlVk12ckhuL2c5SEZEZjJ3QTZGQkoyQ2l5c3U4Z3EKQUFBQmtnODBISkVBQUFRREFFZ3dSZ0loQU5ZZk9iUGFnNUQ0VDh6NFRGTkUxbnBQRnR3cmRjZDJqN3NJb0p4YgpvbXNkQWlFQXVsQTdCNTQ3enN5dExJcmFDNk5LaWJKNjRWUE5SZDJKOFM0YkFvTk5ZdVlBZGdCOVdSNFM0WGdxCmV4eGhaM3hlL2ZqUWgxd1VvRTZWbnJrREw5a09qQzU1dUFBQUFaSVBOQnlHQUFBRUF3QkhNRVVDSVFEbVJsMXAKRldzckowb0RSOTY2WXpuMFZFbHRxQ0ZhWktLRXdGOHBnNTg4TXdJZ0twWitOOUdzdFNLNlBxdkR1dU9QWkFGUQp4aUdqc25iR1hEVjFpK3NsZ0pvQWRRRG0wakZqUUhlTXdSQkJCdGR4dWM3QjBrRDJsb1NHKzdxSE1oMzlIamVPClVBQUFBWklQTkJ5bUFBQUVBd0JHTUVRQ0lDK2p5N0VqR3RiVEpYZXEwU3R0NVhPSTUzSDJlM3prZEtHeTVHOFcKN1lPdkFpQndaVzR4V29SV0JPNHkreERvaDRtczRjeGJ5c29VZTZpQUlPbDJuWUYvMnpBTkJna3Foa2lHOXcwQgpBUXNGQUFPQ0FRRUFvckdqQmxaZmh2Yy91WGtqUTdMQWx1TENpRmczakZPekVpWERWeml0a0RhUm0rYkxlYzR5CmFSRjlpbVVHd1JkUnlsV0gzTHd0dGlxcHA2Ky81dGVaMW83Nkl2ZnRNa2dEbjVSSUFNSHBrREljakI4d1ZNNHAKOVVpdGxMRGFSWGswUVFqNjJhOHBCZkhSaWhyajZUMXNES3cwZ1VldWhNK283dzNjNEhEc05PRkxTVndBMEdzdgozVGgvSTRaZWpYSzdDRW45Z3pjMGFUQ2xvSklmMjFrYXBGdkJid0N5Z05iK01md0c5SE95cGdyWVVqdFgxaktiClUzRElKY2pDaFNVOGJOTllUWDJVNGlsaXNOYkZRc0w4dE1CZ3dwbTV6ajByNWlYTENmUTMzZkk0Q05UcmZQK0gKNmVhZnpYank0T2hqaEgvU1ZkNGFwdHdPbnpYeDVIZDdyQT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0=',
                          memberKvkk:
                              'https://piapiri-std.b-cdn.net/KVKK%20Form/%C3%9Cnl%C3%BCCo%20-%20Piapiri%20Uygulama%20Ayd%C4%B1nlatma%20Metni(452390804.1).pdf',
                        );
                        ServiceLocatorManager.environmentReset().whenComplete(
                          () => router.pushAndPopUntil(
                            const SplashRoute(),
                            predicate: (_) => false,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  InkWell environmentButton({
    required IconData icon,
    required String text,
    required Function() onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                icon,
                size: 40,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
