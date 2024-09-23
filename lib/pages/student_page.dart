import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:shout_out_app/services/students_firestore.dart';

class StudentPage extends StatefulWidget {
  final String id;
  final String name;
  final String studentId;

  const StudentPage({
    super.key,
    required this.id,
    required this.name,
    required this.studentId,
  });

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage>
    with SingleTickerProviderStateMixin {
  // student firestore
  final firestoreService = FirestoreService();
  // controller
  final TextEditingController _messageController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  // List of Filipino and additional bad words
  final List<String> _badWords = [
    'puta ka',
    'bugo',
    'bogo',
    'putang ina',
    'tang ina',
    'tangina',
    'burat',
    'bayag',
    'bobo',
    'bubu',
    'b*b*',
    'bugok',
    'bogok',
    'nognog',
    'tanga',
    'ulol',
    'kantot',
    'anak ka ng puta',
    'jakol',
    'Hudas',
    'Lintik',
    'Gago',
    'Tarantado',
    'Buwisit',
    'Bwisit',
    'Bwesit',
    'Kupal',
    'Leche',
    'Liche',
    'Litse',
    'Ungas',
    'Punyeta',
    'Pucha',
    'Pesteng yawa',
    'Pisti',
    'Piste',
    'Yawa',
    'Pakshet',
    'Boang',
    'Amaw',
    'Amawa',
    'Inamaw',
    'Tonto',
    'Atay',
    'Tinonto',
    'Ataya',
    'Gi-atay',
    'gi atay',
    'Patyon',
    'Animala',
    'Kayata',
    'Kayasa',
    'Iyot',
    'iyota',
    'belat',
    'oten',
    'pisot',
    'lubota',
    'lubuta',
    'lobota',
    'pakno',
    'buto',
    'bakang',
    '2g1c',
    '2 girls 1 cup',
    'acrotomophilia',
    'alabama hot pocket',
    'alaskan pipeline',
    'anal',
    'anilingus',
    'anus',
    'apeshit',
    'arsehole',
    'ass',
    'asshole',
    'assmunch',
    'auto erotic',
    'autoerotic',
    'babeland',
    'baby batter',
    'baby juice',
    'ball gag',
    'ball gravy',
    'ball kicking',
    'ball licking',
    'ball sack',
    'ball sucking',
    'bangbros',
    'bangbus',
    'bareback',
    'barely legal',
    'barenaked',
    'bastard',
    'bastardo',
    'bastinado',
    'bbw',
    'bdsm',
    'beaner',
    'beaners',
    'beaver cleaver',
    'beaver lips',
    'beastiality',
    'bestiality',
    'big black',
    'big breasts',
    'big knockers',
    'big tits',
    'bimbos',
    'birdlock',
    'bitch',
    'bitches',
    'black cock',
    'blonde action',
    'blonde on blonde action',
    'blowjob',
    'blow job',
    'blow your load',
    'blue waffle',
    'blumpkin',
    'bollocks',
    'bondage',
    'boner',
    'boob',
    'boobs',
    'booty call',
    'brown showers',
    'brunette action',
    'bukkake',
    'bulldyke',
    'bullet vibe',
    'bullshit',
    'bung hole',
    'bunghole',
    'busty',
    'butt',
    'buttcheeks',
    'butthole',
    'camel toe',
    'camgirl',
    'camslut',
    'camwhore',
    'carpet muncher',
    'carpetmuncher',
    'chocolate rosebuds',
    'cialis',
    'circlejerk',
    'cleveland steamer',
    'clit',
    'clitoris',
    'clover clamps',
    'clusterfuck',
    'cock',
    'cocks',
    'coprolagnia',
    'coprophilia',
    'cornhole',
    'coon',
    'coons',
    'creampie',
    'cum',
    'cumming',
    'cumshot',
    'cumshots',
    'cunnilingus',
    'cunt',
    'darkie',
    'date rape',
    'daterape',
    'deep throat',
    'deepthroat',
    'dendrophilia',
    'dick',
    'dildo',
    'dingleberry',
    'dingleberries',
    'dirty pillows',
    'dirty sanchez',
    'doggie style',
    'doggiestyle',
    'doggy style',
    'doggystyle',
    'dog style',
    'dolcett',
    'domination',
    'dominatrix',
    'dommes',
    'donkey punch',
    'double dong',
    'double penetration',
    'dp action',
    'dry hump',
    'dvda',
    'eat my ass',
    'ecchi',
    'ejaculation',
    'erotic',
    'erotism',
    'escort',
    'eunuch',
    'fag',
    'faggot',
    'fecal',
    'felch',
    'fellatio',
    'feltch',
    'female squirting',
    'femdom',
    'figging',
    'fingerbang',
    'fingering',
    'fisting',
    'foot fetish',
    'footjob',
    'frotting',
    'fuck',
    'fuck buttons',
    'fuckin',
    'fucking',
    'fucktards',
    'fudge packer',
    'fudgepacker',
    'futanari',
    'gangbang',
    'gang bang',
    'gay sex',
    'genitals',
    'giant cock',
    'girl on',
    'girl on top',
    'girls gone wild',
    'goatcx',
    'goatse',
    'god damn',
    'gokkun',
    'golden shower',
    'goodpoop',
    'goo girl',
    'goregasm',
    'grope',
    'group sex',
    'g-spot',
    'guro',
    'hand job',
    'handjob',
    'hard core',
    'hardcore',
    'hentai',
    'homoerotic',
    'honkey',
    'hooker',
    'horny',
    'hot carl',
    'hot chick',
    'how to kill',
    'how to murder',
    'huge fat',
    'humping',
    'incest',
    'intercourse',
    'jack off',
    'jail bait',
    'jailbait',
    'jelly donut',
    'jerk off',
    'jigaboo',
    'jiggaboo',
    'jiggerboo',
    'jizz',
    'juggs',
    'kike',
    'kinbaku',
    'kinkster',
    'kinky',
    'knobbing',
    'leather restraint',
    'leather straight jacket',
    'lemon party',
    'livesex',
    'lolita',
    'lovemaking',
    'make me come',
    'male squirting',
    'masturbate',
    'masturbating',
    'masturbation',
    'menage a trois',
    'milf',
    'missionary position',
    'mong',
    'motherfucker',
    'mound of venus',
    'mr hands',
    'muff diver',
    'muffdiving',
    'nambla',
    'nawashi',
    'negro',
    'neonazi',
    'nigga',
    'nigger',
    'nig nog',
    'nimphomania',
    'nipple',
    'nipples',
    'nsfw',
    'nsfw images',
    'nude',
    'nudity',
    'nutten',
    'nympho',
    'nymphomania',
    'octopussy',
    'omorashi',
    'one cup two girls',
    'one guy one jar',
    'orgasm',
    'orgy',
    'paedophile',
    'paki',
    'panties',
    'panty',
    'pedobear',
    'pedophile',
    'pegging',
    'penis',
    'phone sex',
    'piece of shit',
    'pikey',
    'pissing',
    'piss pig',
    'pisspig',
    'playboy',
    'pleasure chest',
    'pole smoker',
    'ponyplay',
    'poof',
    'poon',
    'poontang',
    'punany',
    'poop chute',
    'poopchute',
    'porn',
    'porno',
    'pornography',
    'prince albert piercing',
    'pthc',
    'pubes',
    'pussy',
    'queaf',
    'queef',
    'quim',
    'raghead',
    'raging boner',
    'rape',
    'raping',
    'rapist',
    'rectum',
    'reverse cowgirl',
    'rimjob',
    'rimming',
    'rosy palm',
    'rosy palm and her 5 sisters',
    'rusty trombone',
    'sadism',
    'santorum',
    'scat',
    'schlong',
    'scissoring',
    'semen',
    'sex',
    'sexcam',
    'sexo',
    'sexy',
    'sexual',
    'sexually',
    'sexuality',
    'shaved beaver',
    'shaved pussy',
    'shemale',
    'shibari',
    'shit',
    'shitblimp',
    'shitty',
    'shota',
    'shrimping',
    'skeet',
    'slanteye',
    'slut',
    's&m',
    'smut',
    'snatch',
    'snowballing',
    'sodomize',
    'sodomy',
    'spastic',
    'spic',
    'splooge',
    'splooge moose',
    'spooge',
    'spread legs',
    'spunk',
    'strap on',
    'strapon',
    'strappado',
    'strip club',
    'style doggy',
    'suck',
    'sucks',
    'suicide girls',
    'sultry women',
    'swastika',
    'swinger',
    'tainted love',
    'taste my',
    'tea bagging',
    'threesome',
    'throating',
    'thumbzilla',
    'tied up',
    'tight white',
    'tit',
    'tits',
    'titties',
    'titty',
    'tongue in a',
    'topless',
    'tosser',
    'towelhead',
    'tranny',
    'tribadism',
    'tub girl',
    'tubgirl',
    'tushy',
    'twat',
    'twink',
    'twinkie',
    'two girls one cup',
    'undressing',
    'upskirt',
    'urethra play',
    'urophilia',
    'vagina',
    'venus mound',
    'viagra',
    'vibrator',
    'violet wand',
    'vorarephilia',
    'voyeur',
    'voyeurweb',
    'voyuer',
    'vulva',
    'wank',
    'wetback',
    'wet dream',
    'white power',
    'whore',
    'worldsex',
    'wrapping men',
    'wrinkled starfish',
    'xx',
    'xxx',
    'yaoi',
    'yellow showers',
    'yiffy',
    'zoophilia',
    '🖕'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  // Function to check for bad words
  bool _containsBadWords(String text) {
    for (String word in _badWords) {
      if (text.toLowerCase().contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  // Function to show a dialog with a custom message
  void _showMessageDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showNameChoiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Choose Name Option'),
          content: const Text(
              'Do you want to send the message with your real name or anonymously?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Real Name'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendMessage(widget.name);
              },
            ),
            TextButton(
              child: const Text('Anonymous'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendMessage('ANONYMOUS');
              },
            ),
          ],
        );
      },
    );
  }

  void _sendMessage(String senderName) {
    // Handle send button press
    firestoreService.addMessage(
      _messageController.text,
      senderName,
      widget.studentId,
    );

    // Clear textfield
    _messageController.clear();

    // Show success dialog
    _showSuccessDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C6E49),
      body: SafeArea(
        child: Column(
          children: [
            // First Flexible (flex 10)
            Flexible(
              flex: 10,
              child: FadeTransition(
                opacity: _animation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 8,
                    color: const Color(0xFF4C956C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  widget.name,
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFEFEE3),
                                  ),
                                  speed: const Duration(milliseconds: 100),
                                ),
                              ],
                              totalRepeatCount: 1,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              widget.studentId,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFFFEFEE3),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Second Flexible (flex 20)
            Flexible(
              flex: 14,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(_animation),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Disclaimer',
                          style: TextStyle(
                            fontSize: 26,
                            color: Color(0xFFFEFEE3),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Please refrain from using any inappropriate language. Continuing to post such content may result in a visit to the Dean`s Office. We have the means to identify users.',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFFEFEE3),
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Third Flexible (flex 4)
            Flexible(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        maxLength: 150,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(color: Color(0xFF2C6E49)),
                        decoration: InputDecoration(
                          hintText: 'Enter your message',
                          hintStyle: const TextStyle(color: Color(0xFF4C956C)),
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Color(0xFFFFA500), width: 2),
                          ),
                          fillColor: const Color(0xFFFEFEE3),
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                        onChanged: (text) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1 + 0.1 * _animation.value,
                          child: child,
                        );
                      },
                      child: IconButton(
                        icon: const Icon(Icons.send,
                            color: Color(0xFFFFA500), size: 35),
                        onPressed: () {
                          // Check for bad words
                          if (_containsBadWords(_messageController.text)) {
                            // Show dialog if bad words are found
                            _showMessageDialog('Warning',
                                'Inappropriate words have been detected. Please refrain from using them.');
                            return;
                          }

                          // Show name choice dialog
                          _showNameChoiceDialog();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Success!'),
          content: const Text('Your message has been sent successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
