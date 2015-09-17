#!/bin/sh

#afplay music player Ver_1.0.0

IFS=$'\n'
MUSICDIR="/Users/User/Music/iTunes/iTunes Media/Music/"

findlist=''
list2=''
list3=''
playlist=''
musictmp=''
playnumber=1

#音楽を検索
echo
echo "afplay music player  Ver_1.0.0"
echo "キーワードを入力"
read keyword
echo
findlist=$(find "${MUSICDIR}" -iname "*$keyword*" -type f)
list2=$(echo "${findlist//${MUSICDIR}/}")
list3=$(echo "${list2//.m4a/\n}")

#検索リストから選択
select music in ${list3}
do
    if [ -z $music ] ; then
      continue
    else
      break
    fi
done
playlist+=$(echo "${music}\n")
musictmp=$music

#音楽再生
nohup afplay "${MUSICDIR}${music}.m4a" &
echo
echo "再生中 ${music}"
echo "l プレイリスト表示"
echo "n 次の曲を再生"
echo "f 検索 → 再生"
echo "a 検索 → プレイリスト追加"
echo "q 終了"
echo

#再生中の操作
while read operation
do
	#プレイリスト表示
	#番号以外が入力された場合プレイリスト表示中止
	if [ ${operation} = 'l' ] ; then
		select music in ${playlist}
		do
		    if [ -z $music ] ; then
				break
		    else
		    	killall afplay
		    	musictmp=$music
		    	playnumber=$(echo "${playlist}" | grep -n "${musictmp}")
		    	playnumber=$(echo "${playnumber//:${musictmp}/}")
		    	nohup afplay "${MUSICDIR}${music}.m4a" &
				break
		    fi
		done
		echo
		echo "再生中 ${musictmp}"
		echo "l プレイリスト表示"
		echo "n 次の曲を再生"
		echo "f 検索 → 再生"
		echo "a 検索 → プレイリスト追加"
		echo "q 終了"
		echo

	#検索　→　再生
	elif [ ${operation} = 'f' ] ; then
		echo
		echo "検索 → 再生"
		echo "キーワードを入力"
		read keyword
		echo
		findlist=$(find "${MUSICDIR}" -iname "*$keyword*" -type f)
		list2=$(echo "${findlist//${MUSICDIR}/}")
		list3=$(echo "${list2//.m4a/\n}")

		#検索リストから選択
		select music in ${list3}
		do
		    if [ -z $music ] ; then
		    	break
		    else
		    	break
		    fi
		done
		playlist+=$(echo "\n${music}\n")
		killall afplay
		musictmp=$music
		nohup afplay "${MUSICDIR}${music}.m4a" &
		let playnumber=${playnumber}+1
		echo
		echo "再生中 ${music}"
		echo "l プレイリスト表示"
		echo "n 次の曲を再生"
		echo "f 検索 → 再生"
		echo "a 検索 → プレイリスト追加"
		echo "q 終了"
		echo

	#検索　→　プレイリスト追加
	elif [ ${operation} = 'a' ] ; then
		echo
		echo "検索 → プレイリスト追加"
		echo "キーワードを入力"
		read keyword
		echo
		findlist=$(find "${MUSICDIR}" -iname "*$keyword*" -type f)
		list2=$(echo "${findlist//${MUSICDIR}/}")
		list3=$(echo "${list2//.m4a/\n}")

		#検索リストから選択
		select music in ${list3}
		do
		    if [ -z $music ] ; then
		    	break
		    else
		    	playlist+=$(echo "\n${music}\n")
		    	break
		    fi
		done
		echo
		echo "再生中 ${musictmp}"
		echo "l プレイリスト表示"
		echo "n 次の曲を再生"
		echo "f 検索 → 再生"
		echo "a 検索 → プレイリスト追加"
		echo "q 終了"
		echo

	#次の曲を再生
	elif [ ${operation} = 'n' ] ; then
		let playnumber=${playnumber}+1
		music=$(echo "${playlist}" | awk "NR==$playnumber")
		killall afplay
		musictmp=$music
		nohup afplay "${MUSICDIR}${musictmp}.m4a" &
		echo
		echo "再生中 ${musictmp}"
		echo "l プレイリスト表示"
		echo "n 次の曲を再生"
		echo "f 検索 → 再生"
		echo "a 検索 → プレイリスト追加"
		echo "q 終了"
		echo

	#再生を停止
	elif [ ${operation} = 'q' ] ; then
		killall afplay
	fi
done
