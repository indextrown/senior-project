# 데이터 제거 확인을 위해 현재는 데이터를 임시로 넣었음
# 일정과 장소 둘다 null값이면 필요없는 데이터로 판단하고 지우는 코드

data = {
    "1": {"가수": "피한울", "작성자": "@2024_HBD_PHW", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/2024_HBD_PHW/status/1788524319821414826"},
    "2": {"가수": "노튼 캠벨", "작성자": "@HBD0319NORTON", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/HBD0319NORTON/status/1788523223849779678"},
    "3": {"가수": "백현", "작성자": "@kk15352969", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/kk15352969/status/1788522922887278846"},
    "4": {"가수": "백현", "작성자": "@lovely_050622", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/lovely_050622/status/1788521963255914833"},
    "5": {"가수": "null", "작성자": "@yangdo4454", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/yangdo4454/status/1788520579622146323"},
    "6": {"가수": "null", "작성자": "@uing0277", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/uing0277/status/1788520294552084789"},
    "7": {"가수": "서애덕", "작성자": "@aduckhbd0923", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/aduckhbd0923/status/1788519536800772380"},
    "8": {"가수": "서애덕", "작성자": "@aduckhbd0923", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/aduckhbd0923/status/1788519530396045479"},
    "9": {"가수": "null", "작성자": "@12102_sk", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/12102_sk/status/1788519357712392379"},
    "10": {"가수": "스가와라", "작성자": "@sugawaraHBD", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/sugawaraHBD/status/1788518792567611869"},
    "11": {"가수": "백현", "작성자": "@yangdo04566", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/yangdo04566/status/1788517852766736766"},
    "12": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788517136924856736"},
    "13": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788517081283244287"},
    "14": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788517017512997230"},
    "15": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788516873023484022"},
    "16": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788516806891901076"},
    "17": {"가수": "null", "작성자": "@Ding_Dorong", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/Ding_Dorong/status/1788516804270379443"},
    "18": {"가수": "null", "작성자": "@babbabbab333000", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/babbabbab333000/status/1788516734301077851"},
    "19": {"가수": "시라부 켄지로", "작성자": "@HPB_shirabu", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/HPB_shirabu/status/1788531486293172717"},
    "20": {"가수": "소녀시대", "작성자": "@inferno7967", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/inferno7967/status/1788531262359245176"},
    "21": {"가수": "소녀시대", "작성자": "@inferno7967", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/inferno7967/status/1788531230650360012"},
    "22": {"가수": "아이유", "작성자": "@inferno7967", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/inferno7967/status/1788531199486620124"},
    "23": {"가수": "아이유", "작성자": "@iubirthday", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/iubirthday/status/1788530840907186228"},
    "24": {"가수": "null", "작성자": "@Pumpkin_ndoor", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/Pumpkin_ndoor/status/1788529692645241113"},
    "25": {"가수": "백현", "작성자": "@yangdogeol961", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/yangdogeol961/status/1788528400740794847"},
    "26": {"가수": "백현", "작성자": "@yangdo61087", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/yangdo61087/status/1788528254795862369"},
    "27": {"가수": "백현", "작성자": "@mmentmiet", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/mmentmiet/status/1788527009058127975"},
    "28": {"가수": "미연", "작성자": "@searchmiyeon", "일정": "1/30~2/1", "장소": "오엘커피", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=46&no=1&page=1"},
    "29": {"가수": "미연", "작성자": "@searchmiyeon", "일정": "1/28~31", "장소": "카페 소프", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=45&no=1&page=1"},
    "30": {"가수": "미연", "작성자": "@my_princess0131", "일정": "1/28~31", "장소": "홍대 카페식스", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=44&no=1&page=1"},
    "31": {"가수": "미연", "작성자": "@MiyeonChina", "일정": "1/27~31", "장소": "몰리스피크닉", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=43&no=1&page=1"},
    "32": {"가수": "미연", "작성자": "@lovememore_my", "일정": "1/27~31", "장소": "다이버시티", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=42&no=1&page=1"},
    "33": {"가수": "미연", "작성자": "@1reever", "일정": "1/27~31", "장소": "Hertz", "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=g_i_dle&wr_id=41&no=1&page=1"},
    "34": {"가수": "백현", "작성자": "@kito4856", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/kito4856/status/1788526451232481568"},
    "35": {"가수": "null", "작성자": "@cafe_NITA", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/cafe_NITA/status/1788526378809479513"},
    "36": {"가수": "null", "작성자": "@sonjiwoolove", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/sonjiwoolove/status/1788525524085801461"},
    "37": {"가수": "백현", "작성자": "@monbbo_exo", "일정": "null", "장소": "null", "게시글_url": "https://twitter.com/monbbo_exo/status/1788525155733631167"},
    "38": {"가수": "예찬", "작성자": "@yechani_i", "일정": "2024.06.09 ~ 06.13", "장소": "카페 해시태그유 (대전광역시 서구 문정로 160 1층)", "게시글_url": "https://twitter.com/yechani_i/status/1788525138704834801"}
}

# 필터링된 데이터를 저장할 딕셔너리
filtered_data = {}

# 데이터 필터링
for key, value in data.items():
    if value["일정"] != "null" and value["장소"] != "null":
        filtered_data[key] = value
print(filtered_data)

for i in filtered_data:
    print(filtered_data[i])
