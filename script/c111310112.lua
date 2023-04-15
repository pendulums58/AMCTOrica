--PM(프로토콜 마스터).63 파싱 어드바이저
c111310112.AccessMonsterAttribute=true
function c111310112.initial_effect(c)
	--액세스 소환
	cyan.AddAccessProcedure(c,aux.TRUE,aux.TRUE)
	c:EnableReviveLimit()	
	--소환 성공시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c111310112.thcon)
	e1:SetTarget(c111310112.thtg)
	e1:SetOperation(c111310112.thop)
	c:RegisterEffect(e1)
	--전투 파괴시
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(111310112,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(c111310112.bdocon)
	e2:SetTarget(c111310112.destg)
	e2:SetOperation(c111310112.desop)
	c:RegisterEffect(e2)		
end
function c111310112.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ACCESS)
end
function c111310112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		return g:GetCount()==5
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c111310112.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:Select(p,1,1,nil)
		local tc=sg:GetFirst()
		if sg and Duel.IsExistingMatchingCard(c111310112.thfilter,tp,LOCATION_DECK,0,1,tc,tc:GetCode())	then
			if Duel.SelectYesNo(tp,aux.Stringid(111310112,0)) then
				local th=Duel.SelectMatchingCard(tp,c111310112.thfilter,tp,LOCATION_DECK,0,1,1,tc,tc:GetCode())
				if th:GetCount()>0 then 
					Duel.SendtoHand(th,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,th)
				end
			end
		end
		Duel.ShuffleDeck(p)
	end
end
function c111310112.thfilter(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c111310112.bdocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ad=c:GetAdmin()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and ad~=nil and ad:GetAttack()<bc:GetAttack()
end
function c111310112.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c111310112.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,2,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
