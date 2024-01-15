

-- 한정해제 유틸

--한정해제 효과 개조
local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)	
	if code==65450690 then
		e:SetTarget(cyan.fgtg)
	end

end
function cyan.fgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND
	if Duel.IsPlayerAffectedByEffect(tp,101252000) then loc=loc+LOCATION_DECK end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65450690.filter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,loc)
end