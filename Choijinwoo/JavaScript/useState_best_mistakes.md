## useState & useEffect 주의할 점

<summary>목차</summary>

- [1. 상태 값 업데이트](#1-상태-값-업데이트)
- [2. 조건 별 랜더링](#2-조건-별-랜더링)
- [3. 객체 상태 업데이트](#3-객체-상태-업데이트)
- [4. 상태 값 여러 개일 경우 객체로 전달](#4-상태-값-여러-개일-경우-객체로-전달)
- [5. 잦은 훅 요청](#5-잦은-훅-요청)
- [6. 참조 자료형 의존성](#6-참조-자료형-의존성)
- [7. 패칭 데이터 랜더링](#7-패칭-데이터-랜더링)
- [8. 타입스크립트 반환 타입](#8-타입스크립트-반환-타입)
- [9. 커스텀 훅 기피](#9-커스텀-훅-기피)
- [10. SSR, CSR](#10-ssr-csr)
- [11. 클로저](#11-클로저)
- [12. useEffect 내부 Fetch](#12-useeffect-내부-fetch)

### 1. 상태 값 업데이트

스코프 내부에서 일어나는 함수의 결과는 반영되지 않으니, 변수 사용을 지양하고 콜백 함수로 받아준다. 상황에 따라 변수 사용을 하는 경우도 있다.

```jsx
// Don't
const handleClick = () => {
  setCount(count + 1);
};

// Do
const handleClick = () => {
  setCount((prev) => prev + 1);
};
```

### 2. 조건 별 랜더링

undefined 값에 대비한 조건문 구절은 상태 관련 함수 이전에 나오면 안된다. 그리고 왠만하면 리턴문 안에서 삼항 연산자로 구현하자.

```jsx
return (
  <>{!id ? '아이디를 찾을 수 없습니다.' : <div>환영합니다. {id} 님</div>}</>
);
```

### 3. 객체 상태 업데이트

객체는 상태 업데이트 식을 쓸 때 주의해야 한다.

```jsx
const [user, setUser] = useState({ name: "", city: "", age: 0 })

const handleChange = (e) => {
	setUser((pre) => {
		...prev,
		name: e.target.value,
	})
}

return (
	<form>
		<inpu type="text" onChange={handleChange} placeholder="your name"/>
	</form>
)
```

### 4. 상태 값 여러 개일 경우 객체로 전달

폼 요소의 경우 업데이트 할 상태 값이 여러 개 있는 경우가 많다. 이를 여러 개의 상태 값으로 가져가기보다는 하나의 객체 형태로 처리하는 것이 바람직하다.

> input의 `name` 요소와 객체의 key 값이 매칭된다. `e.target.name`

```jsx
const [form, setForm] = useState({
  firstName: '',
  lastName: '',
  email: '',
  password: '',
  address: '',
});

const handleChange = (e) => {
  setForm((prev) => ({
    ...form,
    [e.target.name]: e.target.value,
  }));
};

return (
  <form>
    <input
      type='text'
      onChange={handleChange}
      name='firstName'
      placeholder='first name'
    />
    <input
      type='text'
      onChange={handleChange}
      name='lastName'
      placeholder='last name'
    />
    ...
  </form>
);
```

### 5. 잦은 훅 요청

매번 상태 값을 구하기 위해 훅을 사용하기보다는 어떻게 코드를 줄일 수 있을지 강구해야 한다. 불필요한 리소스 낭비를 줄이자.

```jsx
// don't
const [totalPrice, setTotalPrice] = useState(0);

useEffect(() => {
  setTotalPrice(quantity * PRICE_PER_ITEM);
}, [quantity]);

// do
const totalPrice = quantity * PRICE_PER_ITEM;
```

### 6. 참조 자료형 의존성

자바스크립트의 참조형 타입은 주소를 반환하기 때문에 같은 요소로 판단하지 않는다. 그래서 useEffect의 의존성을 객체에 걸게 되면 의도치 않게 잦은 리랜더링을 경험할 수 있으니 원시형 타입의 자료에 의존성을 걸도록 하자.

```jsx
// 버튼을 클릭해도 리랜더링 안된다.
const [price, setPrice] = useState(0)

const handleClick = () => {
	setPrice(0)
}

useEffect(() => {], [price])

<button onClick={handleClick}>button</button>

// 객체를 의존하고 있기 때문에 버튼을 클릭할 때마다 리랜더링 된다.
const [price, setPrice] = useState({number:100, totalPrice: 10000})

const handleClick = () => {
	setPrice({number:100, totalPrice: 10000})
}

useEffect(() => {], [price])

<button onClick={handleClick}>button</button>

// 위의 상황을 피하려면 최대한 원시형 타입을 지정한다.
useEffect(() => {], [price.number])
```

### 7. 패칭 데이터 랜더링

객체를 서버에서 받아온 후 랜더링 하는 부분에서 자주 발생하는 실수다. 받아온 객체 데이터를 화면의 첫 랜더링 시에 표시하고자 하는데 아직 값이 없다면 에러가 발생한다. useEffect의 의존성을 빈 값으로 채우면 첫 마운트 시에 안의 함수를 동작 시키게 되는데, 화면은 이미 마운트가 되었기 때문에 함수와 랜더링 간의 시간 간극이 생기게 된다.

```jsx
// dont'
const [post, setPost] = useState()

useEffect(() => {
	fetch("https://dummyjson.com/posts/1")
	.then((res) => res.json())
	.then((data) => {
		setPost(data)
	})
}, [])

return (
	<article>
		<h1>{post.title}</h1>
		<p>{post.body}</p>
	</article>
)

// do
// 초기값으로 null
// 상태값 뒤에 ? optional chaining 으로 값이 없을 수도 있다고 안
const [post, setPost] = useState(null)

useEffect(() => {
	fetch("https://dummyjson.com/posts/1")
	.then((res) => res.json())
	.then((data) => {
		setPost(data)
	})
}, [])

return (
	<article>
		<h1>{post?.title}</h1>
		<p>{post?.body}</p>
	</article>
)

// best
// loading 상태 값으로 처리 (리액트 쿼리 사용하면 더 직관적이고 쉬워짐)
const [post, setPost] = useState(null)
const [loading, setLoading] = useState(true)

useEffect(() => {
	fetch("https://dummyjson.com/posts/1")
	.then((res) => res.json())
	.then((data) => {
		setPost(data)
		setLoading(false)
	})
}, [])

return (
	<article>
		{loading ? ("로딩중...") : (
				<h1>{post.title}</h1>
				<p>{post.body}</p>
			)
		}
	</article>
)
```

하지만 useEffect 내에서 fetch를 하는 것이 과연 바람직할까?

### 8. 타입스크립트 반환 타입

useState를 사용하며 초기 값의 타입을 명시할 필요가 없다. 초기 값을 통해 유추하기 때문이다. 하지만 객체는 객체의 타입을 미리 선언해서 명시해줘야 한다. 초기 값을 선언해도 되지만 null로 지정할 경우에는 null 도 같이 포함시켜 준다.

```tsx
type Post = {
  title: string;
  body: string;
};

const [post, setPost] = useSTate<Post | null>(null);
```

### 9. 커스텀 훅 기피

반복되는 훅은 커스텀으로 만들어서 사용하자.

```tsx
const useIndowSize = () => {
	...
}

// Comp1.jsx
const windowsize = useWindowSize();

// Comp2.jsx
const windowsize = useWindowSize();
```

### 10. SSR, CSR

상태 관련 함수, 브라우저에서 가동되는 함수는 클라이언트 사이드에서 써야 한다. 해당 부분만 컴포넌트 화 하여 임포트 후 사용하는 것이 일반적.

### 11. 클로저

위에서 나왔던 내용과 중복되지만 가시적으로 구별하기 힘든 부분 중 하나이다. count 상태값이 항상 그대로이기 때문에 이 부분을 수정해야 한다.

```tsx
// don't do
// 콘솔 창 메시지만 작동한다.
const [count, setCount] = useState(0);

useEffect(() => {
  setInterval(() => {
    console.log('인터벌 작동 중');
    setCount(count + 1);
  }, 1000);
}, []);

// do
// best
useEffect(() => {
  setInterval(() => {
    console.log('인터벌 작동 중');
    setCount((prev) => prev + 1);
  }, 1000);
}, []);
```

### 12. useEffect 내부 Fetch

제일 잦은 실수다. 데이터 패칭이 일어나야 할 지점을 의존성으로 주입해야 하는데 그 부분을 간과하게 된다. 예를 들어 빈 배열의 첫 랜더링 시만 일어나는 패칭인데, 부분 컴포넌튼만 업데이트해야 하는 경우 이는 제대로 작동하지 않는다.

SWR 사용하면 코드가 더 간결해지고 읽기 쉬워지니, 상황에 맞게 사용해보자.
