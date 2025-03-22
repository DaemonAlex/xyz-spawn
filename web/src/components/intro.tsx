import { useState, useCallback } from 'react';
import { Button, Container, Group, Image, Center, Text, Title } from '@mantine/core';
import { fetchNui } from '../utils/fetchNui';
import logo from '../images/logo.png';

export default function HeroText() {
  const [hideContent, setHideContent] = useState(false);

  const handleButtonClick = useCallback(() => {
    fetchNui('forge-introplayer');
    setHideContent(true);
  }, []);

  return (
    <div className={hideContent ? 'hidden' : ''}>
      <Container size={1400}>
        <Group position="apart" mt="md" mb="xs">
          <div>
            <div>
              <Center>
                <Image src={logo} width={240} height={240} radius="lg" alt="XYZ Logo" />
              </Center>
            </div>
            <Title color="white" order={2}>
              WELCOME TO{' '}
              <Text component="span" color="yellow" weight={700}>
                XYZ ROLEPLAY
              </Text>
            </Title>
            <Container p={0} size={600}>
              <Text size="lg" color="white">
                Begin your journey by creating a character and exploring XYZ.
              </Text>
            </Container>
            <Button size="lg" onClick={handleButtonClick} aria-label="Start Journey">
              BEGIN YOUR JOURNEY
            </Button>
          </div>
        </Group>
      </Container>
    </div>
  );
}
