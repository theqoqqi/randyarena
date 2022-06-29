--
-- Created by IntelliJ IDEA.
-- User: Qoqqi
-- Date: 21.10.2018
-- Time: 2:10
-- To change this template use File | Settings | File Templates.
--

CreatorController = class({});

function CreatorController:Create(randyArena, options)

	local instance = CreatorController();

	instance.gameStartRubickLaughs = {
		"rubick_rubick_laugh_06",
		"rubick_rubick_laugh_07",
	};

	return instance;
end

function CreatorController:OnGameInProgress()
	EmitGlobalSound(RandomFromTable(self.gameStartRubickLaughs));
end

function CreatorController:OnAllHeroesInGame()
	self.creatorEntity = Entities:FindByName(nil, 'the_creator');
	self.platformEntity = Entities:FindByName(nil, 'creators_platform');

	if DEBUG_DISABLE_CREATOR then
		UTIL_Remove(self.creatorEntity);
		UTIL_Remove(self.platformEntity);
		return;
	end

	-- self.platformOffset = self.platformEntity:GetAbsOrigin() - self.creatorEntity:GetAbsOrigin();
	-- self.platformNormOffset = self.platformOffset:Normalized();

	-- print(self.platformOffset);
	-- print(self.platformNormOffset);

	-- self.maxMoveSpeed = 700;

	self.moveFromPosition = self.creatorEntity:GetAbsOrigin();
	self.moveToPosition = Vector(400, 0, 600);
	self.lookAtPosition = Vector(0, 0, 512);
	self.currentMoveDuration = 0;
	self.targetMoveDuration = 1;

	-- self:PlayGreetings();

	Timers:CreateTimer(2.02, function()
		self:OnThink(0.02);
		return 0.02;
	end);

	Timers:CreateTimer(5, function()
		self.moveFromPosition = self.creatorEntity:GetAbsOrigin();
		self.moveToPosition = RandomVector(1000);
		self.moveToPosition.z = 700;
		self.lookAtPosition = Vector(0, 0, 512);
		self.currentMoveDuration = 0;
		self.targetMoveDuration = 1;
		return 5;
	end);
end

function CreatorController:OnThink(deltaTime)

	if self.currentMoveDuration >= self.targetMoveDuration then
		return;
	end

	self.currentMoveDuration = self.currentMoveDuration + deltaTime;

	local absOrigin = self.creatorEntity:GetAbsOrigin();
	local angles = self.creatorEntity:GetAngles();
	
	local delta = self.currentMoveDuration / self.targetMoveDuration;
	local pos = Lerp(self.moveFromPosition, self.moveToPosition, delta);
	local dir = VectorToAngles(self.lookAtPosition - absOrigin).y;

	self.creatorEntity:SetAbsOrigin(pos);
	self.creatorEntity:SetAngles(angles.x, dir, angles.z);
end

function RandyArena:PlayGreetings()
	local playList = {};
	local playerIds = RandyArena:GetShuffledPlayerIds();
	--	EmitGlobalSound(RandomFromTable(self.gameStartRubickLaughs));

	for i, playerId in pairs(playerIds) do

		local heroEntity = Players:GetHeroEntity(playerId);
		local heroName = ParseHeroName(heroEntity:GetClassname());
		local heroSounds = HERO_SOUND_NAMES[heroName];

		if heroSounds ~= nil then
			local heroSoundEvents = heroSounds['hero_events'];

			if heroSoundEvents ~= nil then
				local soundNames = heroSoundEvents['default_greeting'];

				local soundName = RandomFromTable(soundNames);
				local soundDuration = heroEntity:GetSoundDuration(soundName, nil);

				table.insert(playList, {
					soundName = soundName,
					soundDuration = soundDuration,
				});
			end
		end
	end

	table.insert(playList, {
		soundName = RandomFromTable(self.gameStartRubickLaughs),
		soundDuration = 0,
	});

	local timeOffset = 3;

	for i, soundInfo in pairs(playList) do
		Timers:CreateTimer(timeOffset, function()
			EmitGlobalSound(soundInfo.soundName);
		end);
		timeOffset = timeOffset + soundInfo.soundDuration;
	end
end

function Step(from, to, stepSize)
	local pos = to - from;
	if SqrLength(pos) <= stepSize * stepSize then
		pos = to;
	else
		pos = from + pos:Normalized() * stepSize;
	end
	return pos;
end

function Lerp(from, to, delta)
	delta = math.min(delta, 1);
	return from + (to - from) * delta;
end

function SqrLength(v)
	return v.x * v.x + v.y * v.y + v.z * v.z;
end