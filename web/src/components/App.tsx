import React, { useState, createContext, useEffect, memo } from 'react';
import { debugData } from '../utils/debugData';
import Sidebar from '../components/navbar';
import { MantineProvider } from '@mantine/core';
import HeroText from '../components/intro';
import { useNuiEvent } from '../hooks/useNuiEvent';

debugData([{ action: 'setVisible', data: true }]);

const IsNew = createContext<IsNew | null>(null);

interface IsNew {
  setIsSidebarOpen: (isOpen: boolean) => void;
  isNew: boolean;
}

const App: React.FC = () => {
  const [isNew, setNew] = useState(false);

  useEffect(() => {
    useNuiEvent<boolean>('IsNew', setNew);
  }, []);

  return (
    <MantineProvider theme={{ colorScheme: 'dark' }}>
      {isNew ? <MemoizedHeroText /> : <MemoizedSidebar />}
    </MantineProvider>
  );
};

const MemoizedSidebar = memo(Sidebar);
const MemoizedHeroText = memo(HeroText);

export default App;
