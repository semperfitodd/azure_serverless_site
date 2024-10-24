module.exports = async function (context, req) {
    const facts = [
        "Bananas are berries, but strawberries aren't.",
        "A group of flamingos is called a 'flamboyance'.",
        "Octopuses have three hearts.",
        "Honey never spoils.",
        "A cow-bison hybrid is called a beefalo."
    ];

    const randomFact = facts[Math.floor(Math.random() * facts.length)];

    context.res = {
        body: randomFact
    };
};
