import { createStyles, Badge, Group, Title, Text, Card, SimpleGrid, Container, Avatar, Transition } from '@mantine/core';
import { useEffect, useState, useCallback } from 'react';
import { useNuiEvent } from '../hooks/useNuiEvent';
import Typewriter from "typewriter-effect";

const mockdata = [
  {
    title: 'MoneSuper',
    description: "Believe in yourself!",
    Image: 'https://i.imgur.com/PKp6NvD.jpeg',
    badge: 'Project Developer',
    badgecolor: 'yellow'
  }
];

const useStyles = createStyles(() => ({
  title: { fontSize: '2rem', fontWeight: 900 },
  featuresCards: { display: 'flex', justifyContent: 'center', minHeight: '100vh' }
}));

export function FeaturesCards() {
  const { classes } = useStyles();
  const [currentData, setCurrentData] = useState(mockdata);
  const [userName, setUserName] = useState('JENNA FOSTER');

  const updateUserName = useCallback((data: { name: string }) => setUserName(data.name), []);
  useNuiEvent('userinfo', updateUserName);

  return (
    <Container size="xl" py="md">
      <Group position="center" style={{ marginTop: '-10vh' }}>
        <Badge color="green" variant="light" size="lg">Status: Online</Badge>
      </Group>
      <Title color="white" order={1} className={classes.title} ta="center" mt="sm">
        <Typewriter options={{ strings: ['WELCOME BACK TO XYZ ROLEPLAY', userName], autoStart: true, loop: true }} />
      </Title>
      <SimpleGrid cols={3} spacing="xl" mt={50} breakpoints={[{ maxWidth: 'md', cols: 1 }]}>
        {currentData.map((feature, index) => (
          <Transition key={index} mounted={true} transition="fade">
            {(transitionStyles) => (
              <Card key={index} shadow="md" radius="md" className={classes.card} padding="xl" style={{ ...transitionStyles, zIndex: 3 - index }}>
                <Group>
                  <Avatar size={70} radius="xl" src={feature.Image} alt={feature.title} mb="md" />
                  <Badge color={feature.badgecolor} variant="light" size="md">{feature.badge}</Badge>
                </Group>
                <Text fz="lg" fw={500} className={classes.cardTitle} mt="md">{feature.title}</Text>
                <Text fz="sm" c="dimmed" mt="sm">{feature.description}</Text>
              </Card>
            )}
          </Transition>
        ))}
      </SimpleGrid>
    </Container>
  );
}
