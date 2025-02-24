# mesh_frontend

A new Flutter project.

## 環境構築

.vscode/launch.json に以下の設定を追加してください。

```json
{
    // IntelliSense を使用して利用可能な属性を学べます。
    // 既存の属性の説明をホバーして表示します。
    // 詳細情報は次を確認してください: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
    
        {
            "name": "mesh_frontend",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=GOOGLE_MAPS_API_KEY=[API_KEY]"
            ]
        },
        {
            "name": "mesh_frontend (profile mode)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=GOOGLE_MAPS_API_KEY=[API_KEY]"
            ],
            "flutterMode": "profile"
        },
        {
            "name": "mesh_frontend (release mode)",
            "request": "launch",
            "type": "dart",
            "args": [
                "--dart-define=GOOGLE_MAPS_API_KEY=[API_KEY]"
            ],
            "flutterMode": "release"
        }
    ]
}
```