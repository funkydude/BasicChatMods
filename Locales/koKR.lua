
if GetLocale() ~= "koKR" then return end
local _, L = ...
L["CORE"] = "BasicChatMods에 오신 걸 환영합니다, 기본 모듈형 접근 방식으로 대화를 사용자 설정합니다. 접근 방식때문에 BCM은 몇몇 변경에 /reload가 필요하도록 설계되었습니다.\n\n기본적으로 BCM은 대화창을 화면 모서리 끝까지 드래그 할 수 있게 해줍니다, 나머지 사용자 설정은 활성화 또는 비활성화 시킬 수 있는 BCM의 모듈로 완료할 수 있습니다.\n\n BCM이 모듈을 비활성하면 메모리를 사용하지 않습니다, 사용하지 않는 건 비활성하세요!"
L["WARNING"] = "<<변경 사항을 적용하려면 /reload 해야 합니다>>"
L["OPTIONS"] = "<<이 모듈을 활성화 해야 더 많은 옵션을 사용할 수 있습니다>>"

L["BCM_AltInvite"] = "대화창의 모든 플레이어 이름을 ALT-클릭으로 자신의 그룹에 초대할 수 있게합니다."
L["BCM_AutoLog"] = "로그온 후 자동으로 대화 내용을 기록하며 공격대 인스턴스 안에선 전투 로그를 자동으로 기록합니다."
L["BCM_BNet"] = "괄호를 변경하거나 귓속말, 대화, 친구 접속과 같은 여러 실명 Id 이벤트에 색상을 추가합니다."
L["BCM_ButtonHide"] = "대화 창 가장자리 버튼을 사용하지 않는 사람들을 위해 완전히 숨깁니다."
L["BCM_ChannelNames"] = "선호하는 사용자 설정 이름으로 채널 이름을 선택적으로 대체합니다. 예. [파티] >> [P]"
L["BCM_ChatCopy"] = "이 모듈은 대화창 탭을 |cFFFFFFFFSHIFT-클릭|r하여 대화창의 내용을 직접 복사할 수 있게 해줍니다."
L["BCM_EditBox"] = "상단으로 이동, 배경 숨기기, 크기 키우기 등과 같은 방법으로 대화 입력창을 사용자 설정합니다."
L["BCM_Fade"] = "대화창에서 마우스가 벗어나면 대화창의 일부 대신 전체를 서서히 숨깁니다."
L["BCM_Font"] = "대화창 & 대화 입력창의 글꼴 이름, 크기, 모양을 변경합니다."
L["BCM_GMOTD"] = "10초 후에 주 대화창에 오늘의 길드 메시지를 다시 표시합니다."
L["BCM_Highlight"] = "대화에 자신의 이름이 언급되면 소리를 재생하며 직업 색상을 입힙니다. 아래 박스에 자신의 예명을 입력할 수 있습니다."
L["BCM_History"] = "대화창이 얼마나 많은 대화 내용을 기억할 지 설정합니다."
L["BCM_PlayerNames"] = "플레이어 레벨/그룹 (알고 있을 때) 또는 괄호 제거/변경으로 대화의 플레이어 이름을 사용자 설정합니다. 예. [85:|cFFFFFFFF멋진사제|r:5]"
L["BCM_Justify"] = "여러 대화창의 문자를 오른쪽, 왼쪽, 또는 대화창의 중앙으로 정렬합니다."
L["BCM_Resize"] = "블리자드가 허용한 것보다 대화창의 크기를 더 작게/크게 변경할 수 있게 해줍니다."
L["BCM_ScrollDown"] = "대화창 스크롤이 최하단이 아니면 반짝이는 클릭 가능 한 작은 화살표를 대화창 위에 만듭니다"
L["BCM_Sticky"] = "'고정' 대화를 사용자 설정합니다. 다음에 대화할 때 다시 입력하지 않도록 대화 입력창이 최근에 사용한 대화 유형을 기억하게 합니다"
L["BCM_TellTarget"] = "/tt 내용 또는 /wt 내용 명령어로 현재 대상에게 귓속말/대화할 수 있게 해줍니다."
L["BCM_Timestamp"] = "대화창에 사용하고 싶은대로 대화 시각을 사용자 설정합니다. 색상을 넣거나, 대화 시각의 정확한 형식을 선택합니다."
L["BCM_URLCopy"] = "쉽게 복사할 수 있도록 대화창의 웹사이트를 클릭 가능한 링크로 바꿔줍니다. 예. |cFFFFFFFF[www.battle.net]|r"

L["BNETICON"] = "%s 아이콘을 제거합니다."
L["FAKENAMES"] = "실명을 캐릭터 이름으로 대체합니다."

L["SIZE"] = "크기"

L["CHATLOG"] = "항상 대화 내용을 기록합니다."
L["COMBATLOG"] = "공격대 인스턴스에서 전투를 기록합니다."

L["TOP"] = "상단"
L["BOTTOM"] = "하단"

L["LEFT"] = "왼쪽"
L["RIGHT"] = "오른쪽"
L["CENTER"] = "중앙"

L["GENERAL"] = "공개"
L["TRADE"] = "거래"
L["WORLDDEFENSE"] = "전역수비"
L["LOCALDEFENSE"] = "지역수비"
L["LFG"] = "파티찾기"
L["GUILDRECRUIT"] = "길드찾기"
L["CHANNELNUMBER"] = "채널 숫자"
L["CHANNELNAME"] = "채널 이름"
L["CUSTOMCHANNEL"] = "사용자 채널"

L["SHOWLEVELS"] = "이름 뒤에 플레이어 레벨을 표시합니다."
L["SHOWGROUP"] = "이름 뒤에 플레이어의 그룹을 표시합니다."
L["COLORMISC"] = "친구/길드원 접속 메시지에 직업 색상을 사용합니다."
L["PLAYERBRACKETS"] = "플레이어 괄호:"

L["CLICKTOCOPY"] = "Shift-클릭으로 대화를 복사합니다."

--BCM.protectedText = "<Protected Text>"
--L.TRADE_SERVICES = "Trade (Services)"
