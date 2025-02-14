
# Rotating 3D ASCII Cube in Pascal 🎮📦🧊➰

Um programa Pascal que renderiza um cubo 3D rotativo usando caracteres ASCII no console. Projeto demonstra conceitos de:
- **Geometria 3D**
- **Projeção perspectiva**
- **Rotação de objetos**
- **Double buffering** com `z-buffer`

## 🌐 Fundamentos Matemáticos
### Matrizes de Rotação 3D ([Fonte](https://en.wikipedia.org/wiki/Rotation_matrix))
[Inspiração👉](https://www.youtube.com/watch?v=p09i_hoFdd0&ab_channel=ServetGulnaroglu) 
O cubo gira usando combinações de matrizes de rotação em 3 eixos:

#### 1. Rotação nos Eixos Individuais
| Eixo | Matriz | Implementação no Código |
|------|--------|-------------------------|
| **X** | <img src="7.png" width="200"> | `j*Cos(A)`, `k*Sin(A)` |
| **Y** | <img src="8.png" width="200"> | `i*Cos(B)`, `k*Sin(B)` |
| **Z** | <img src="9.png" width="200"> | `j*Cos(C)`, `i*Sin(C)` |

#### 2. Rotação Combinada (Euler Angles)
As funções `CalculateX/Y/Z` combinam as 3 rotações usando a ordem Z → Y → X:
```pascal
// Cálculo X combina rotações Y (B) e Z (C)
j*Sin(A)*Sin(B)*Cos(C) - k*Cos(A)*Sin(B)*Cos(C) + 
j*Cos(A)*Sin(C) + k*Sin(A)*Sin(C) + 
i*Cos(B)*Cos(C)
```

#### 3. Projeção Perspectiva
A coordenada 3D → 2D usa:
```
ooz = 1/z (inverso da profundidade)
xp = (x * K1 * ooz) + offset
yp = (y * K1 * ooz) * -1 (inverte eixo Y)
```
<img src="10.png" width="400">

## 🧮 Implementação das Fórmulas
### Cálculo de Coordenadas 3D
```pascal
function CalculateX(i, j, k: Real): Real;
begin
  CalculateX := 
    j*Sin(A)*Sin(B)*Cos(C) - k*Cos(A)*Sin(B)*Cos(C) + // Rotação Y+Z
    j*Cos(A)*Sin(C) + k*Sin(A)*Sin(C) +                // Rotação X+Z
    i*Cos(B)*Cos(C);                                   // Componente principal X
end;
```

### Sistema de Coordenadas
| Componente | Variável | Função |
|------------|----------|--------|
| Profundidade | `z` | Define escala da projeção |
| Offset Horizontal | `horizontalOffset` | Centraliza no terminal |
| Escala | `K1` | Controla "campo de visão" |

## 🖼️ Espaço para Imagens (Adicione 3 screenshots)
1. **Diagrama de Rotação**  
   ![Exemplo Rotação XYZ](1.png)

2. **Equações Completas**  
   ![Equações Expandidas](4.png)

3. **Projeção 3D→2D**  
   ![Diagrama Projeção](2.png)

## 🔄 Fluxo de Transformações
1. **Rotação 3D**  
   `(i,j,k) → (x,y,z) via matrizes`
2. **Projeção Perspectiva**  
   `(x,y,z) → (xp,yp) via ooz`
3. **Oclusão**  
   `zBuffer resolve sobreposições`

## 📚 Recursos Adicionais
- [Artigo sobre Matrizes de Rotação](https://en.wikipedia.org/wiki/Rotation_matrix)
- [Sistemas de Coordenadas 3D](https://en.wikipedia.org/wiki/3D_projection)
- [Depth Buffering](https://en.wikipedia.org/wiki/Z-buffering)


## 📋 Estrutura Principal

### Variáveis Globais
```pascal
var
  A, B, C: Real;        // Ângulos de rotação nos eixos X/Y/Z
  cubeWidth: Real;       // Tamanho do cubo (metade da aresta)
  width, height: Integer;// Dimensões do terminal
  zBuffer: array of Real;// Buffer de profundidade
  buffer: array of Char; // Buffer de renderização
  K1: Real;              // Constante de escalonamento perspectiva
```

### 🔑 Componentes Chave

1. **Inicialização**
   - `InitializeVariables`: Configura parâmetros iniciais
   - `InitializeBuffers`: Prepara buffers com caracteres de fundo ('.')

2. **Cálculos 3D**
   ```pascal
   function CalculateX/Y/Z(i,j,k: Real): Real
   ```
   - Fórmulas de rotação 3D usando matrizes de rotação
   - Combinação de rotações nos 3 eixos (A,B,C)

3. **Projeção Perspectiva**
   ```pascal
   ooz := 1 / z;  // "One over z" para efeito perspectiva
   xp := ... + K1 * ooz * x;  // Projeção X
   yp := ... - K1 * ooz * y;  // Projeção Y (eixo invertido)
   ```

4. **Renderização**
   - `CalculateForSurface`: Projeta pontos 3D → 2D com:
     - Verificação de profundidade (`zBuffer`)
     - Atribuição de caracteres diferentes por face (`@`, `$`, `~`, etc.)
   - `RenderFrame`: Desenha todas as 6 faces do cubo

## 🎮 Como Funciona
1. **Loop Principal**
   ```pascal
   repeat
     RenderFrame;
     Delay(0);  // ~60 FPS
   until False;
   ```
2. **Animação**
   - Incrementa ângulos de rotação a cada frame:
   ```pascal
   A += 0.05; B += 0.05; C += 0.01;
   ```

3. **Otimizações**
   - `zBuffer` evita sobreposição incorreta de pixels
   - Buffer de caracteres para renderização rápida

## 🛠️ Personalização
```pascal
// Experimente alterar:
cubeWidth := 15;       // Cubo maior
width := 120;          // Terminal mais largo
backgroundASCIICode := ' ';  // Fundo vazio
K1 := 60;              // Perspectiva mais extrema
```

## 📦 Dependências
- Compilador Pascal (Free Pascal/Turbo Pascal)
- Unit `crt` para manipulação de console

## 🚀 Como Executar
```bash
fpc rotating_cube.pas && ./rotating_cube
```

## 🔍 Detalhes Técnicos Interessantes
- **ASCII Art 3D**: Uso criativo de caracteres para representação 3D
- **Depth Buffering**: Técnica profissional usada em jogos 3D
- **Matrizes de Rotação**: Implementação manual sem bibliotecas gráficas
- **Otimização de Performance**: Renderização direta no console

## 📌 Possíveis Melhorias
- [x] Adicionar controle de FPS preciso
- [ ] Implementar input do usuário
- [ ] Adicionar cores (ANSI escape codes)
- [ ] Sistema de partículas rotativas

<img src="giphy.gif" alt="Cubo 3D Rotativo" width="450" height="300"/>  

*Projeto educativo para entender fundamentos de gráficos 3D!* 🎓


# created by - Panda12332145 

![Panda12332145' Instagram Profile Picture](https://scontent-gru1-1.cdninstagram.com/v/t51.2885-19/117600834_654064835492344_4051007124330294069_n.jpg?stp=dst-jpg_s150x150_tt6&_nc_ht=scontent-gru1-1.cdninstagram.com&_nc_cat=104&_nc_oc=Q6cZ2AGzi7nuJGYfI5pToRe8PalArBoSQlsQZBQp_Gv89OA_BhXQtSOQsG6FPBTsqwG22Js&_nc_ohc=_mq6YnNl_x0Q7kNvgF8Zvi6&_nc_gid=df0f0866d3e64a5898f5d7b9c21119c2&edm=AP4sbd4BAAAA&ccb=7-5&oh=00_AYCepHqPUAmSlH_gYWOKpDPLYWKuX1mlYgI5-uCyeuxuuA&oe=67B43BEB&_nc_sid=7a9f4b)  

## 🧑‍💻 Sobre Mim  
Sou um apaixonado por **Física Teórica, Cibersegurança e Desenvolvimento de Sistemas**. Busco constantemente **conhecimento profundo** em áreas como hacking, programação de baixo nível e computação avançada. Tenho interesse em **engenharia reversa, criptografia e segurança da informação**, além de um grande apreço por música, filosofia e linguagens.  

## 🌐 Conecte-se Comigo  
- **🔗 Site:** [meusite.com](https://panda-h0me.netlify.app/)  
- **📺 YouTube:** [youtube.com/@X86BinaryGhost](https://www.youtube.com/@X86BinaryGhost)  
- **📸 Instagram:** [@01pandal10](https://www.instagram.com/01pandal10/)  
- **🖥 GitHub:** [github.com/panda12332145](https://github.com/panda12332145)  

## 🚀 Áreas de Interesse  
- **Cibersegurança Avançada** 🔒  
- **Hacking & Engenharia Reversa** 💻  
- **Computação de Baixo Nível** 🖥️  
- **Matemática e Física Teórica** 📐⚛️  
- **Música e Filosofia** 🎵📖  

_"Conhecimento é poder, e a verdadeira liberdade vem do domínio sobre a informação."_  

---

📩 Para colaborações e projetos, sinta-se à vontade para me contatar! [📧Enviar e-mail para Panda12332145](mailto:amandasyscallinjector@gmail.com?subject=Interesse%20no%20projeto%20MAAPC&body=Olá%20Panda12332145,%0D%0A%0D%0AEspero%20que%20este%20e-mail%20lhe%20encontre%20bem.%20tive%20a%20oportunidade%20de%20conhecer%20seu%20projeto%20MAAPC%20no%20GitHub.%0D%0A%0D%0AFiquei%20muito%20interessado%20na%20abordagem%20e%20nas%20funcionalidades%20do%20projeto%20e%20gostaria%20de%20conversar%20mais%20sobre%20ele.%20Se%20possível,%20poderia%20compartilhar%20mais%20detalhes%20ou%20até%20mesmo%20discutirmos%20sobre%20possíveis%20colaborações?%0D%0A%0D%0AAgradeço%20desde%20já%20pela%20atenção%20e%20aguardo%20seu%20retorno.)
