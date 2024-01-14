--미래를 거래하는 행상인
local s,id=GetID()
function s.initial_effect(c)
	--링크 소환
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_EFFECT),2,2)
	c:EnableReviveLimit()	
	--소환시
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cyan.LinkSSCon)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(s.op)	
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	s.purchase(tp)
end
function s.purchase(tp)
	--거래 개시
	--거래 풀에서 무작위로 3개 선택(겹치지 않도록)
	--링크 행상인은 원하는 분류의 카드를 뽑아줌
	--카드 등급은 커먼, 언커먼, 레어로 구분하여 각 등급별 확률 적용
	local buf=Duel.SelectYesNo(tp,aux.Stringid(id,0))
	--이후, 선택지에 따라서 해당하는 타입의 카드를 판매함.
	local op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,5))
	local common={}
	local uncommon={}
	local rare={}
	if op==0 then
		--돌파 카드
			--오리카
				--뱀부스피어 제너럴, 페네트레이트 로드, 시계탑 봉인집행자, 매스 디나이얼, 몰?루 프레이어, 괴뢰직시자 플루토, 
			--비오리카
				--라이트닝 스톰, 번개, 해피의 깃털, 금지된 일적, 용암 마신 라바 골렘, 티 폰, 삼전의 호, 삼전의 재, 사탄클로스, 무한포영, 키메라테크 메가프릿 드래곤, 크샤트리라 펜리르
			-- 총 18매. 10 / 5 / 3매 (레어만 3개 제시되는 경우가 있으므로)
		--커먼 등급
			--뱀부스피어 제너럴, 메가프리트 외 나머지 전부
		common={101223186,87116928,101213303,101223181,101220033,14532163,12580477,18144506,102380,93039339}
		
		--언커먼 등급
			--삼전의 호, 페네트레이트 로드, 금지된 일적, 사탄클로스, 무한포영
		uncommon={35269904,101223192,24299458,46565218,10045474}			
		
		--레어 등급
			--크샤트리라 펜리르, 매스 디나이얼, 삼전의 재
		rare={32909498,101223243,25311006}
	elseif op==1 then
		--어드밴티지 확보 카드
			--오리카
				--드림 오브 크리스탈, 운명을 거래하는 행상인, 영원 커넥터, 퓨전 서포터, 모여드는 초목의 행진, 전생의 우연, 래바이브 리사이클러, 창천의 집배원, 청룡신 아트라시온, 방랑병장 순간개방, 원천 제간타, 심해의 파멸 자이루다, 엄동설한 명령, 통상소원의 데이드리머
			--비오리카
				--욕망의 항아리, 천사의 자비, 제육감, 욕망과 탐욕의 항아리, 욕망과 졸부의 항아리, 증식의 G, 탐욕의 항아리, 합승, 치킨게임, 루드라의 마도서, 삼전의 재, 링크 버스트, 바운드링크, 악몽의 신기루, 소환제한 - 엑스트라넷, 심판의 천평칭, 활로를 향한 희망, 쌓아 올리는 행복, 탐욕의 단지, 어둠의 증산공장
			--총 34매. 18 / 10 / 6매
			--커먼 등급
				--운명을 거래하는 행상인 외 나머지
			common={101223236,111310071,111310117,101223074,101223224,35261759,49238328,67169062,1372887,67616300,73287067,51335426,95376428,67443336,80036543,98444741,98954106,9064354}			
			--언커먼 등급
				--영원 커넥터, 모여드는 초목의 행진, 전생의 우연, 청룡신 아트라시온, 방랑병장 순간개방, 삼전의 재, 루드라의 마도서, 증식의 G, 원천 제간타, 심해의 파멸 자이루다
			uncommon={101223222,101223146,101223169,111310144,103553012,25311006,23314220,23434538,101223034,101223032}
			--레어 등급
				--욕망의 항아리, 천사의 자비, 악몽의 신기루, 제육감, 퓨전 서포터, 드림 오브 크리스탈
			rare={55144522,79571449,41482598,3280747,101223105,101223183}
	end
	-- 커먼 확률 60%, 언커먼 확률 30%, 레어 확률 10%
	local goods=Group.CreateGroup()
	local rarity=0
	local maxrare=0
	while #goods<3 do
		local gacha=Duel.GetRandomNumber(1,100)
		if gacha<=60 then
			rarity=1
			if maxrare < rarity then
				maxrare=rarity
			end
		elseif gacha<=90 then
			rarity=2
			if maxrare < rarity then
				maxrare=rarity
			end
		else
			rarity=3
			if maxrare < rarity then
				maxrare=rarity
			end
		end
		local token=0
		if rarity==1 then
			token=common[Duel.GetRandomNumber(1,#common)]
		elseif rarity==2 then
			token=uncommon[Duel.GetRandomNumber(1,#uncommon)]
		elseif rarity==3 then
			token=rare[Duel.GetRandomNumber(1,#rare)]
		end
		if not goods:IsExists(Card.IsCode,1,nil,token) then
			token=Duel.CreateToken(tp,token)
			goods:AddCard(token)
		end
	end
	if maxrare == 3 then
		local a = Duel.SelectOption(tp,aux.Stringid(id,2))
	elseif maxrare == 2 then
		local a = Duel.SelectOption(tp,aux.Stringid(id,3))
	else
		local a = Duel.SelectOption(tp,aux.Stringid(id,4))
	end
	local g=goods:Select(tp,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end	
	
	 
end