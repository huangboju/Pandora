
#import "RainforestCardInfo.h"

NSString const* BIRD_BASE_URL = @"https://www.raywenderlich.com/downloads/Progressive_Images/Birds";
NSString const* MAMMAL_BASE_URL = @"https://www.raywenderlich.com/downloads/Progressive_Images/Mammals";
NSString const* REPTILE_BASE_URL = @"https://www.raywenderlich.com/downloads/Progressive_Images/Reptiles";

@implementation RainforestCardInfo

+ (NSArray *)allAnimals
{
    return [[[self birdCards] arrayByAddingObjectsFromArray:[self mammalCards]] arrayByAddingObjectsFromArray:[self reptileCards]];
}

+ (NSArray *)birdCards
{
    NSDictionary *parrotData     = @{@"name": @"Parrot", @"imageURL": [NSString stringWithFormat:@"%@/blueHeadedParrot.jpg", BIRD_BASE_URL], @"animalDescription": @"The blue-headed parrot, also known as the blue-headed pionus (Pionus menstruus) is a medium large parrot. It is about 27 cm long and they are mainly green with a blue head and neck, and red under tail feathers.[2] It is a resident bird in tropical and subtropical South America and southern Central America, from Costa Rica, Venezuela and Trinidad south to Bolivia and Brazil. It is named for its medium-blue head and neck."};
    NSDictionary *harpyEagleData = @{@"name": @"Harpy Eagle", @"imageURL": [NSString stringWithFormat:@"%@/HarpyEagle.jpg", BIRD_BASE_URL], @"animalDescription": @"The harpy eagle (Harpia harpyja) is a neotropical species of eagle. It is sometimes known as the American harpy eagle to distinguish it from the Papuan eagle, which is sometimes known as the New Guinea harpy eagle or Papuan harpy eagle.[3] It is the largest and most powerful raptor found in the Americas,[4] and among the largest extant species of eagles in the world. It usually inhabits tropical lowland rainforests in the upper (emergent) canopy layer. Destruction of its natural habitat has caused it to vanish from many parts of its former range, and it is nearly extirpated in Central America. In Brazil, the harpy eagle is also known as royal-hawk (in Portuguese: gavião-real)."};
    NSDictionary *loveBirdData   = @{@"name": @"Love Bird", @"imageURL": [NSString stringWithFormat:@"%@/LoveBird.jpg", BIRD_BASE_URL], @"animalDescription": @"A lovebird is one of nine species of the genus Agapornis (Greek: αγάπη agape 'love'; όρνις ornis 'bird'). They are a social and affectionate small parrot. Eight species are native to the African continent, and the grey-headed lovebird is native to Madagascar. Their name stems from the parrots' strong, monogamous pair bonding and the long periods which paired birds spend sitting together. Lovebirds live in small flocks and eat fruit, vegetables, grasses and seed. Black-winged lovebirds also eat insects and figs, and the black-collared lovebirds have a special dietary requirement for native figs, making them problematic to keep in captivity."};
    NSDictionary *macawBirdData  = @{@"name": @"Macaw", @"imageURL": [NSString stringWithFormat:@"%@/Macaw.jpg", BIRD_BASE_URL], @"animalDescription": @"Of the many different Psittacidae (true parrots) genera, six are classified as macaws: Ara, Anodorhynchus, Cyanopsitta, Primolius, Orthopsittaca, and Diopsittaca. Previously, the members of the genus Primolius were placed in Propyrrhura, but the former is correct in accordance with ICZN rules.[2] Macaws are native to Central America and North America (only México), South America, and formerly the Caribbean. Most species are associated with forests, especially rainforests, but others prefer woodland or savannah-like habitats."};
    NSDictionary *mergusDuckData = @{@"name": @"Mergus Duck", @"imageURL": [NSString stringWithFormat:@"%@/MergusDuck.jpg", BIRD_BASE_URL], @"animalDescription": @"Mergus[1] is the genus of the typical mergansers, fish-eating ducks in the seaduck subfamily (Merginae). The hooded merganser, often termed Mergus cucullatus, is not of this genus but closely related. The other \"aberrant\" merganser, the smew (Mergellus albellus), is phylogenetically closer to goldeneyes (Bucephala)."};
    
    RainforestCardInfo *parrotInfo     = [[self alloc] initWithDictionary:parrotData];
    RainforestCardInfo *harpyEagleInfo = [[self alloc] initWithDictionary:harpyEagleData];
    RainforestCardInfo *loveBirdInfo   = [[self alloc] initWithDictionary:loveBirdData];
    RainforestCardInfo *macawInfo      = [[self alloc] initWithDictionary:macawBirdData];
    RainforestCardInfo *mergusDuckInfo = [[self alloc] initWithDictionary:mergusDuckData];
    
    return @[parrotInfo, harpyEagleInfo, loveBirdInfo, macawInfo, mergusDuckInfo];
}

+ (NSArray *)mammalCards
{
    NSDictionary *jaguarData = @{@"name": @"Jaguar", @"imageURL": [NSString stringWithFormat:@"%@/Jaguar.jpg", MAMMAL_BASE_URL], @"animalDescription": @"The jaguar (Panthera onca) is a big cat, a feline in the Panthera genus, and is the only extant Panthera species native to the Americas. The jaguar is the third-largest feline after the tiger and the lion, and the largest in the Americas. The jaguar's present range extends from Southwestern United States and Mexico across much of Central America and south to Paraguay and northern Argentina. Apart from a known and possibly breeding population in Arizona (southeast of Tucson) and the bootheel of New Mexico, the cat has largely been extirpated from the United States since the early 20th century."};
    NSDictionary *margayCatData = @{@"name": @"Margay Cat", @"imageURL": [NSString stringWithFormat:@"%@/MargayCat.jpg", MAMMAL_BASE_URL], @"animalDescription": @"The margay (Leopardus wiedii) is a small cat native to Central and South America that is listed as near threatened by the IUCN since 2008 because remaining populations are thought to be declining due to loss of habitat following conversion of forests."};
    NSDictionary *monkeyData = @{@"name": @"Monkey", @"imageURL": [NSString stringWithFormat:@"%@/monkey.jpg", MAMMAL_BASE_URL], @"animalDescription": @"Monkeys are haplorhine (\"dry-nosed\") primates, a paraphyletic group generally possessing tails and consisting of approximately 260 known living species. Many monkey species are tree-dwelling (arboreal), although there are species that live primarily on the ground, such as baboons. Most species are also active during the day (diurnal). Monkeys are generally considered to be intelligent, particularly Old World monkeys."};
    NSDictionary *northernTamanduaData  = @{@"name": @"Northern Tamandua", @"imageURL": [NSString stringWithFormat:@"%@/northernTamandua.jpg", MAMMAL_BASE_URL], @"animalDescription": @"The northern tamandua (Tamandua mexicana) is a species of tamandua, a small anteater in the family Myrmecophagidae. They live in tropical and subtropical forests from southern Mexico, through Central America, and to the edge of the northern Andes."};
    NSDictionary *slothData = @{@"name": @"Sloth", @"imageURL": [NSString stringWithFormat:@"%@/sloth.jpg", MAMMAL_BASE_URL], @"animalDescription": @"Sloths (/ˈsloʊθ/ slohth, /ˈslɒθ/ sloth) are medium-sized mammals belonging to the families Megalonychidae (two-toed sloth) and Bradypodidae (three-toed sloth), classified into six species. They are part of the order Pilosa and are therefore related to anteaters, which sport a similar set of specialized claws. Extant sloths are arboreal (tree-dwelling) residents of the jungles of Central and South America, and are known for being slow-moving, and hence named \"sloths\". Extinct sloth species include a few species of marine sloths and many megafaunal ground sloths, some of which attained the size of elephants."};
    
    RainforestCardInfo *jaguarInfo           = [[self alloc] initWithDictionary:jaguarData];
    RainforestCardInfo *margayCatInfo        = [[self alloc] initWithDictionary:margayCatData];
    RainforestCardInfo *monkeyInfo           = [[self alloc] initWithDictionary:monkeyData];
    RainforestCardInfo *northernTamanduaInfo = [[self alloc] initWithDictionary:northernTamanduaData];
    RainforestCardInfo *slothInfo            = [[self alloc] initWithDictionary:slothData];
    
    return @[jaguarInfo, margayCatInfo, monkeyInfo, northernTamanduaInfo, slothInfo];
}

+ (NSArray *)reptileCards
{
    NSDictionary *alligatorData = @{@"name": @"Alligator", @"imageURL": [NSString stringWithFormat:@"%@/Alligator.jpg", REPTILE_BASE_URL], @"animalDescription": @"An alligator is a crocodilian in the genus Alligator of the family Alligatoridae. The two living species are the American alligator (A. mississippiensis) and the Chinese alligator (A. sinensis). In addition, several extinct species of alligator are known from fossil remains. Alligators first appeared during the Paleocene epoch about 37 million years ago."};
    NSDictionary *beardedDragonData = @{@"name": @"Bearded Dragon", @"imageURL": [NSString stringWithFormat:@"%@/BeardedDragon.jpg", REPTILE_BASE_URL], @"animalDescription": @"Pogona is a genus of reptiles containing eight lizard species, which are often known by the common name bearded dragons. The name \"bearded dragon\" refers to the \"beard\" of the lizard, the underside of the throat which turns black if they are stressed or see a potential rival. They are adept climbers, spending time on branches and in bushes and near human habitation. Pogona species bask on rocks and exposed branches in the mornings and afternoons. They are found throughout much of Australia in a wide range of habitats such as deserts, shrublands and Eucalyptus woodlands."};
    NSDictionary *komodoDragonData   = @{@"name": @"Komodo Dragon", @"imageURL": [NSString stringWithFormat:@"%@/KomodoDragon.jpg", REPTILE_BASE_URL], @"animalDescription": @"The Komodo dragon[4] (Varanus komodoensis), also known as the Komodo monitor, is a large species of lizard found in the Indonesian islands of Komodo, Rinca, Flores, Gili Motang, and Padar.[5] A member of the monitor lizard family Varanidae, it is the largest living species of lizard, growing to a maximum length of 3 metres (10 ft) in rare cases and weighing up to approximately 70 kilograms (150 lb)."};
    NSDictionary *spectacledCaimanData  = @{@"name": @"Spectacled Caiman", @"imageURL": [NSString stringWithFormat:@"%@/SpectacledCaiman.jpg", REPTILE_BASE_URL], @"animalDescription": @"The spectacled caiman (Caiman crocodilus), also known as the white caiman or common caiman, is a crocodilian reptile found in much of Central and South America.[1] It lives in a range of lowland wetland and riverine habitat types, and can tolerate salt water, as well as fresh; due in part to this adaptability, it is the most common of all crocodilian species."};
    NSDictionary *tRexData = @{@"name": @"T-Rex", @"imageURL": [NSString stringWithFormat:@"%@/TRex.jpg", REPTILE_BASE_URL], @"animalDescription": @"Tyrannosaurus (/tᵻˌrænəˈsɔːrəs/ or /taɪˌrænəˈsɔːrəs/, meaning \"tyrant lizard\", from the Ancient Greek tyrannos (τύραννος), \"tyrant\", and sauros (σαῦρος), \"lizard\"[1]) is a genus of coelurosaurian theropod dinosaur. The species Tyrannosaurus rex (rex meaning \"king\" in Latin), commonly abbreviated to T. rex, is one of the most well-represented of the large theropods. Tyrannosaurus lived throughout what is now western North America, on what was then an island continent known as Laramidia. Tyrannosaurus had a much wider range than other tyrannosaurids. Fossils are found in a variety of rock formations dating to the Maastrichtian age of the upper Cretaceous Period, 68 to 66 million years ago.[2] It was the last known member of the tyrannosaurids,[3] and among the last non-avian dinosaurs to exist before the Cretaceous–Paleogene extinction event."};
    
    RainforestCardInfo *alligatorInfo        = [[self alloc] initWithDictionary:alligatorData];
    RainforestCardInfo *beardedDragonInfo    = [[self alloc] initWithDictionary:beardedDragonData];
    RainforestCardInfo *komodoDragonInfo     = [[self alloc] initWithDictionary:komodoDragonData];
    RainforestCardInfo *spectacledCaimanInfo = [[self alloc] initWithDictionary:spectacledCaimanData];
    RainforestCardInfo *tRexInfo             = [[self alloc] initWithDictionary:tRexData];
    
    return @[beardedDragonInfo, alligatorInfo, komodoDragonInfo, spectacledCaimanInfo, tRexInfo];
}

- (instancetype)initWithDictionary:(NSDictionary *)animalData
{
    if (!(self = [super init])) { return nil; }
    
    self.name = animalData[@"name"];
    self.animalDescription = animalData[@"animalDescription"];
    self.imageURL = [NSURL URLWithString:animalData[@"imageURL"]];
    
    return self;
}

@end
