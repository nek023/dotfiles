########################################################
# システム
########################################################
# .DS_Storeを作成しない
execute 'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'

# バッテリーのパーセントを表示する
execute 'defaults write com.apple.menuextra.battery ShowPercent -string "YES"'

# 日付表示設定: 曜日を表示
execute 'defaults write com.apple.menuextra.clock DateFormat -string "M\u6708d\u65e5(EEE)  H:mm"'

# スクリーンショットの保存形式をPNGにする
execute 'defaults write com.apple.screencapture type -string "png"'

# 保存パネルをデフォルトで開いた状態にする
execute 'defaults write -g NSNavPanelExpandedStateForSaveMode -bool true'


########################################################
# Dock
########################################################
# 拡大: しない
execute 'defaults write com.apple.dock magnification -bool true'

# 画面上の位置: 下
execute 'defaults write com.apple.dock orientation -string "bottom"'

# ウィンドウをしまう時のエフェクト: スケールエフェクト
execute 'defaults write com.apple.dock mineffect -string "scale"'

# ウィンドウのタイトルバーをダブルクリックで: 拡大/縮小
execute 'defaults write -g AppleMiniaturizeOnDoubleClick -bool false'


########################################################
# Mission Control
########################################################
# 最新の使用状況に基づいて操作スペースを自動的に並べ替える: オフ
execute 'defaults write com.apple.dock mru-spaces -bool false'

# アプリケーションウィンドウの切り替えで、アプリケーションのウィンドウが開いている操作スペースに移動: オン
execute 'defaults write -g AppleSpacesSwitchOnActivate -bool true'

# ウィンドウをアプリケーションごとにグループ化: オフ
execute 'defaults write com.apple.dock expose-group-by-app -bool false'

# ディスプレイごとに個別の操作スペース: オン
execute 'defaults write com.apple.spaces spans-displays -bool true'

# Dashboard: オフ
execute 'defaults write com.apple.dashboard enabled-state -int 1'


########################################################
# ホットコーナー
########################################################
# 左上: デスクトップを表示
execute 'defaults write com.apple.dock wvous-tl-corner -int 4'
execute 'defaults write com.apple.dock wvous-tl-modifier -int 0'

# 左下: デスクトップを表示
execute 'defaults write com.apple.dock wvous-bl-corner -int 4'
execute 'defaults write com.apple.dock wvous-bl-modifier -int 0'

# 右上: Mission Control
execute 'defaults write com.apple.dock wvous-tr-corner -int 2'
execute 'defaults write com.apple.dock wvous-tr-modifier -int 0'

# 右下: Mission Control
execute 'defaults write com.apple.dock wvous-br-corner -int 2'
execute 'defaults write com.apple.dock wvous-br-modifier -int 0'


########################################################
# キーボード
########################################################
# キーのリピート
execute 'defaults write -g KeyRepeat -int 2'

# リピート入力認識までの時間
execute 'defaults write -g InitialKeyRepeat -int 15'


########################################################
# トラックパッド
########################################################
# タップでクリック: 1本指でタップ
execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true'
execute 'defaults write -g com.apple.mouse.tapBehavior -int 1'
execute 'defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1'

# 副ボタンのクリック: 2本指でクリックまたはタップ
execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 0'
execute 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true'
execute 'defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true'
execute 'defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 0'

# 調べる&データ検出: 3本指でタップ


########################################################
# Finder
########################################################
# ステータスバーを表示
execute 'defaults write com.apple.finder ShowStatusBar -bool true'

# パスバーを表示
execute 'defaults write com.apple.finder ShowPathbar -bool true'
