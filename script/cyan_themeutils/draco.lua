EFFECT_DRACO_ADD=15881121
--ȯ�赹�Ŀ�

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)	
	--ȯ�赹�� ȿ�� ����
	--�⺻ ȿ���� �ٸ� �������� ��� �ڽ��� ������� �Ҽ��� �ֵ��� �����Ѵ�
	if code==16960351 and mt.eff_ct[c][1]==e then
		e:SetCost(cyan.dracocost)
	end
end
function cyan.dracocost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,cyan.rfilter,1,nil,e,tp,ft)
		or Duel.IsExistingMatchingCard(cyan.addrfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	local g=Duel.GetReleaseGroup(tp):Filter(cyan.rfilter,nil,e,tp,ft)
	local g1=Duel.GetMatchingGroup(cyan.addrfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	g:Merge(g1)
	local tc1=g:Select(tp,1,1,nil)
	local tc=tc1:GetFirst()
	if tc:IsHasEffect(EFFECT_DRACO_ADD) then
		local le={tc:IsHasEffect(EFFECT_DRACO_ADD)}
		for _,te in pairs(le) do			
			local f1=te:GetValue()
			if type(f1)=="function" then f1=f1(te) end
			e:SetLabel(f1)
		end	
	else
		e:SetLabel(tc:GetOriginalLevel())
	end

	Duel.Release(tc,REASON_COST)
end
function cyan.addrfilter(c,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	local lv=0
	if c:IsHasEffect(EFFECT_DRACO_ADD) then
		local le={c:IsHasEffect(EFFECT_DRACO_ADD)}
		for _,te in pairs(le) do			
			local f1=te:GetValue()
			if type(f1)=="function" then f1=f1(te) end
			lv=f1
		end
	end
	return lv>0 and c:IsReleasable() and Duel.IsExistingMatchingCard(cyan.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function cyan.rfilter(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsRace(RACE_DRAGON) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(cyan.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function cyan.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end