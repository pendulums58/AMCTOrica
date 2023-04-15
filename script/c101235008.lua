--E(에너미).컨티뉴엄-비타
function c101235008.initial_effect(c)
	c:SetSPSummonOnce(101235008)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c101235008.matfilter,1,1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,101235008)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101235008.target)
	e1:SetOperation(c101235008.activate)
	c:RegisterEffect(e1)
end
function c101235008.matfilter(c)
	return c:IsLinkSetCard(0x653)
end
function c101235008.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and chkc:IsFaceup()end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_REMOVED,0,2,2,nil)
end
function c101235008.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local tcode=tc:GetCode()
			Duel.Exile(tc,REASON_EFFECT)
			local token=Duel.CreateToken(tp,tcode)
			Duel.Remove(token,POS_FACEDOWN,REASON_EFFECT)
			tc=g:GetNext()
		end
	end
	local tg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil,nil)
	local ttc=Group.RandomSelect(tg,tp,1)
	local sc=ttc:GetFirst()
	local scode=sc:GetCode()
	Duel.Exile(sc,REASON_EFFECT)
	local token=Duel.CreateToken(tp,scode)
	Duel.Remove(token,POS_FACEUP,REASON_EFFECT)
	if token:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
	if token:IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,token)
	end
end